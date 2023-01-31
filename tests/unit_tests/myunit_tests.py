import unittest
import sys  
sys.path.append("../../functions")

import basicpython.app as main_lambda

class TestCases(unittest.TestCase):
    def test_one(self):
        result = main_lambda.methodOne()
        self.assertEqual(result, True)

    def test_two(self):
        result = main_lambda.methodTwo()
        self.assertEqual(result, False)


if __name__ == '__main__':
    unittest.main()