/*
Write the worst – but working – implementation of FizzBuzz that you can think of. The rules of FizzBuzz are as follows:
For numbers 1 through 100,
if the number is divisible by 3 print Fizz;
if the number is divisible by 5 print Buzz;
if the number is divisible by 3 and 5 (15) print FizzBuzz; else, print the number.
You are welcome to use Swift, Objective C, C# or Java in your implementation. Upload your code to a public repository on Github and email us the link.

*/
import UIKit

// worst... 😂 I only write better code

class FizzBuzz : NSObject{
    
    private let value : Int
    
    init(value : Int) {
        self.value = value
    }
    
    override var description: String {
        guard value >= 1 && value <= 100 else {
//            throw FizzBuzzError()
            return "undefined value : " + value.description
        }
        let divisibleBy3 = self.value % 3 == 0
        let divisibleBy5 = self.value % 5 == 0
        
        var temp = ""
        if divisibleBy3 {
            temp += "Fizz"
        }
        if divisibleBy5 {
            temp += "Buzz"
        }
        if temp.characters.count > 0 {
            return temp
        }else {
            return value.description
        }
    }
}

print(FizzBuzz(value: 3))
print(FizzBuzz(value: 5))
print(FizzBuzz(value: 30))
print(FizzBuzz(value: 31))
print(FizzBuzz(value: 0))

