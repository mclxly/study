import sys
from random import randint

print(sys.version)

#################################################
def readFloats(numberOfInputs):
  print("Enter", numberOfInputs, "numbers:")
  inputs = []
  for i in range(numberOfInputs):
    value = float(input(''))
    inputs.append(value)

  return inputs

def main():
  numbers = readFloats(5)
  print(numbers)

main()

raise SystemExit


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
