import unittest
import requests
import sys  
sys.path.append("../../functions")

import basicpython.app as main_lambda

class TestCases(unittest.TestCase):
    def test_one(self):
        result = main_lambda.methodThree()
        self.assertEqual(result, True)


if __name__ == '__main__':
    unittest.main()