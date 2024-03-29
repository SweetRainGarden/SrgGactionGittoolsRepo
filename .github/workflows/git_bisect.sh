#!/bin/bash


# pre-check for essential parameters

while [ $# -gt 0 ]; do
  if [[ $1 == *"--"* ]]; then
    v="${1/--/}"
    declare -r "$v"="$2"
  fi
  shift
done
required_parameters=("repo_abs_path" "check_commands" "good_commit" "branch")

for parameter in "${required_parameters[@]}"; do
  parameter_value=$(eval echo \$"$parameter")
  if [ -z "$parameter_value" ]; then
    echo "please input parameter --$parameter"
    exit 1
  fi
done

echo ""
echo "--------------------------------------------------------------------------------------"
echo "Input parameters:"
for parameter in "${required_parameters[@]}"; do
  parameter_value=$(eval echo \$"$parameter")
  echo "${parameter} = ${parameter_value}"
done
echo "--------------------------------------------------------------------------------------"
echo ""
echo ""



cd "$repo_abs_path" || exit

git checkout "$branch"
git pull
git fetch

# Resolve bad commit
if [[ -z "$bad_commit" ]]; then
  INIT_BAD_COMMIT_ID=$(git rev-parse HEAD)
elif git rev-parse --verify --quiet "$bad_commit"^{commit}; then
  INIT_BAD_COMMIT_ID=$bad_commit
else
  echo "The specified bad commit is invalid."
  exit 1
fi

# Create the check script
COMMANDS=$(echo "$check_commands" | sed 's/^&&//;s/&&$//')
IFS='&&' read -ra CMD_ARRAY <<< "$COMMANDS"
echo "#!/bin/bash" > bisect_check.sh
for CMD in "${CMD_ARRAY[@]}"; do
  CMD="$(echo "$CMD" | xargs)"
  if [ -n "$CMD" ]; then
    echo "$CMD" >> bisect_check.sh
  fi
done
chmod +x bisect_check.sh

# Run bisect with check command bash
git bisect start
git bisect bad "$INIT_BAD_COMMIT_ID"
git bisect good "$good_commit"
BISECT_OUTPUT=$(git bisect run ./bisect_check.sh)
echo "$BISECT_OUTPUT"
FIRST_BAD_COMMIT=$(git rev-parse bisect/bad)
git bisect reset


echo ""
echo "---------------------- Bisect result -------------------"
if [[ -z "$FIRST_BAD_COMMIT" ]]; then
  echo "------------------------------------------------------"
  echo "No bad commit found."
  echo "------------------------------------------------------"
else
  ERROR_LOG=$(echo "$BISECT_OUTPUT" | awk '/first bad commit: first commit that fails/{flag=1; next} /Bisecting:/{flag=0} flag')
  echo "$ERROR_LOG"
  echo ""
  
  echo "------------------------------------------------------"
  echo "FIRST_BAD_COMMIT: $FIRST_BAD_COMMIT"
  echo "------------------------------------------------------"
fi

