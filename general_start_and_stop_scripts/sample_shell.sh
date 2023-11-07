if grep -c 'Director' ./tmp.txt | grep -q '7'; then
   echo "Success"
   exit 0
else
  echo "Failure"
  exit 1
fi
