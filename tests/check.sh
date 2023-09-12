#!/bin/bash
set -eu

TESTS=( "intro" )
FULL_ARGUMENTS=( "" )
EXPECTED_OUTPUTS=( "Hello world!" )

DARK_GREY='\e[2;30m'
LIGHT_GREY='\e[2;37m'
RED="\e[31m"
GREEN="\e[32m"
NC='\e[0m' # No Color
VISUAL_INDENT=" --"

function log() {
  set +u
  printf "${DARK_GREY}:${LIGHT_GREY}:${NC}:%s%s" "$2" "$1"
  set -u
}
function log_with_newline() {
  set +u
  printf "%s\n" "$(log "$1" "$2")"
  set -u
}
function log_ok() {
  printf "${GREEN}%s${NC}\n" "$1"
}
function log_failed() {
  printf "${RED}%s${NC}\n" "$1"
}

TOTAL_TESTS=$((${#TESTS[@]}))
FAILED_TESTS=0
PASSED_TESTS=0
CURRENT_TEST=0
RESULTS=""

echo
log " Cleaning..."
make clean >/dev/null
log_ok Ok
log " Compiling..."
make all >/dev/null
log_ok Ok
echo "---------------------------------------------------"

set +e
for T in "${!TESTS[@]}"; do
  CURRENT_TEST=$((CURRENT_TEST + 1))
  log_with_newline " Running test $CURRENT_TEST of $TOTAL_TESTS:"
  log_with_newline "${TESTS[T]}"
  log_with_newline "Arguments: ${FULL_ARGUMENTS[T]}"
  log "Running program..." ">${VISUAL_INDENT} "
  OUTPUT=$(./"${TESTS[T]}" ${FULL_ARGUMENTS[T]})
  log_ok Ok
  log "Comparing output..." "<${VISUAL_INDENT} "
  if ! diff <(echo "$OUTPUT") <(echo "${EXPECTED_OUTPUTS[T]}") >/dev/null; then
    FAILED_TESTS=$((FAILED_TESTS + 1))
    log_failed FAILED
    log_with_newline "FILE OUTPUT: $OUTPUT, EXPECTED OUTPUT: ${EXPECTED_OUTPUTS[T]}"
  else
    PASSED_TESTS=$((PASSED_TESTS + 1))
    log_ok PASSED
  fi
done
[[ "$FAILED_TESTS" -gt 0 ]] && log_with_newline " $FAILED_TESTS test(s) $(log_failed "FAILED")" && exit 1
[[ "$PASSED_TESTS" -eq "$TOTAL_TESTS" ]] && log_with_newline " $PASSED_TESTS test(s) $(log_ok "PASSED")"
exit 0