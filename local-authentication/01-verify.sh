[ `http :8080/goals | jq '. | length'` -gt 3 ] && echo "done"
