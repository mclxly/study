# Python Doc:
import sys
from random import randint

print(sys.version)

import datetime
import mysql.connector

cnx = mysql.connector.connect(user='root', password='123456',
                                host='192.168.21.90',
                                database='myblog')
cursor = cnx.cursor()

query = "SELECT user_login FROM wp_users "

cursor.execute(query)

for (user) in cursor:
  print("user: {}".format(
    user[0]))

cursor.close()
cnx.close()

#################################################
# a = []
# a.append({'href': 'haha', 'text': 'cccc'});
# a.append({'href': 'haha2', 'text': 'cccc2'});
# a.append({'href': 'haha3', 'text': 'cccc3'});
# print(a)

#################################################
# from sys import argv

# DEFAULT_KEY = 3

# def main() :
#   key = DEFAULT_KEY
#   inFile = ""
#   outFile = ""
#   files = 0

#   for i in xrange(1, len(argv)):
#     arg = argv[i]
#     if arg[0] == "-":
#       # It's a command line option
#       option = arg[1]
#       if option == 'd':
#         key = -key
#       else:
#         usage()
#         return
#     else:
#       files += 1
#       if files == 1:
#         inFile = arg
#       elif files ==2:
#         outFile = arg

#   if files != 2:
#     usage()
#     return

#   inputFile = open(inFile, 'r')
#   outFile = open(outFile, 'w') 

#   for line in inputFile :
#     for char in line :
#       newChar = encrypt(char, key)
#       outFile.write(newChar)

#   inputFile.close()
#   outFile.close()

# # function
# def encrypt(ch, key) :
#   LETTERS = 26

#   if ch >= 'A' and ch <= 'Z':
#     base = ord("A")
#   elif ch >= 'a' and ch <= 'z':
#     base = ord('a')
#   else:
#     return ch

#   offset = ord(ch) - base + key
#   if offset > LETTERS:
#     offset -= LETTERS
#   elif offset < 0:  
#     offset += LETTERS

#   return chr(base + offset)

# def usage() :
#   print("usage: python cipher.py [-d] infile outfile")

# main()

#################################################
#
# inputFile = open("../wiki.txt", "r",-1,"UTF-8")
# for line in inputFile:
#   # line = line.rsplit()
#   # print(line)
#   wordList = line.split()
#   for word in wordList:
#     word = word.rsplit(".,?!")
#     print(word)

# inputFile.close()

#################################################
# def readFloats(numberOfInputs):
#   print("Enter", numberOfInputs, "numbers:")
#   inputs = []
#   for i in range(numberOfInputs):
#     value = float(input(''))
#     inputs.append(value)

#   return inputs

# def main():
#   numbers = readFloats(5)
#   print(numbers)

# main()

# raise SystemExit


# def main():
#     print("main")

# main()

# raise SystemExit

# CORRECT_ANSWERS = "adbdcacbdac"

# done = False
# while not done:
#     userAnswers = input("Enter your exam answers: ")
#     if len(userAnswers) == len(CORRECT_ANSWERS):
#         done = True
#     else:
#         print("Error: an incorrect number")

# numQuestions = len(CORRECT_ANSWERS)
# numCorrect = 0
# results = ""

# for i in range(numQuestions):
#     if userAnswers[i] == CORRECT_ANSWERS[i]:
#         numCorrect += 1
#         results += userAnswers[1]
#     else:
#         results += "X"

# score = round(numCorrect / numQuestions * 100)

# if score == 100:
#     print("Very Good!")
# else:
#     print("You missed %d questions: %s" % (numQuestions - numCorrect, results))

# print("Your score is: %d percent" % score)
