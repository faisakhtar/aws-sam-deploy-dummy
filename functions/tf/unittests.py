import unittest
import app as mainlambda

class TestCases(unittest.TestCase):
    def test_one(self):
        result = mainlambda.do_something_1()
        self.assertEqual(result, "Sample")

    def test_two(self):
        result = mainlambda.do_something_2()
        self.assertEqual(result, "Sample2")


if __name__ == '__main__':
    unittest.main()