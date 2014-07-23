# A Dictionary of Sets
def main():
  indexEntries = {}

  infile = open("indexdata.txt", "r")
  fields = extractRecord(infile)
  while len(fields) > 0 :
    addWord(indexEntries, fields[1], fields[0])
    fields = extractRecord(infile)

  infile.close()

  printIndex(indexEntries)

def extractRecord(infile) :
  line = infile.readline()
  if line != "" :
    fields = line.split(":")
    page = int(fields[0])
    term = fields[1].rstrip()
    return [page, term]
  else :
    return []

def addWord(entries, term, page):
  if term in entries :
    pageSet = entries[term]
    pageSet.add(page)
  else :
    pageSet = set([page])
    entries[term] = pageSet

def printIndex(entries) :
  for key in sorted(entries):
    print(key, end=" ")
    pageSet = entries[key]
    first = True
    for page in sorted(pageSet) :
      if first :
        print(page, end="")
        first = False
      else :
        print(",", page, end="")

    print()

main()
