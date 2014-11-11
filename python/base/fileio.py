inputFile = open("stt.csv", "r")

for line in inputFile :
  rows = line.split(",")

  for field in rows :
    print field