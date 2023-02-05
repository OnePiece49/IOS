import UIKit

var greeting = "Hello, playground"

//struct Student {
//    var name: String
//    var age: Int
//}
//
//var arr_name = ["Viet", "Duc Anh", "Bao Long", "Linh", "Huy", "Tuan"]
//var arr_student = [Student(name: "Viet", age: 23), Student(name: "Huy", age: 15), Student(name: "Long", age: 30)]
//
//var arr_result = [5.0, 3.1, 2.8, 4.0, 6.9, 3.7, 8.1, 9.0, 3.6, 7.8]

/* reduce
let arr = arr_result.reduce([:]) { (prevousResult: [String: Int], nextElement: Double) in
    var copy = prevousResult
    switch nextElement {
        case 1..<4: copy["Very bad", default : 0] += 1
        case 4..<6: copy["OK", default : 0] += 1
        case 6..<8: copy["Good", default : 0] += 1
        case 8..<11: copy["Excellent", default : 0] += 1
    default:
        break
    }

    return copy
}

let arrNew = arr_result.reduce(into: [:]) { (prevousResult: inout [String: Int], nextElement: Double) in
    switch nextElement {
        case 1..<4: prevousResult["Very bad", default : 0] += 1
        case 4..<6: prevousResult["OK", default : 0] += 1
        case 6..<8: prevousResult["Good", default : 0] += 1
        case 8..<11: prevousResult["Excellent", default : 0] += 1
    default:
        break
    }
}

print(arr)
print(arrNew)
*/
 
/* ZIP
let students = ["Viet", "Long", "Duc Anh", "Linh"]
let grades = [9, 8, 8.7, 8]

let pair = zip(students, grades)

for student in pair {
    print(student.0)
    print(student.1)
}
*/


/*Nested Function
class SayXinChao {
    func sayHello() {
        func sayHihi() {
            print("Hihi ae wibu")
        }
        
        print("Hello ae wibu")
        sayHihi()
    }
    

}

SayXinChao().sayHello()
*/

/*Lazy
enum Level {
    case easy
    case medium
    case hard
}

struct Exam {
    var level: Level
    
    private(set) lazy var questionExam: [String] = {     //Must be assign value for lazy
        sleep(5)
        switch level {
        case .easy:
            return ["1 + 1 = ?", "2 + 2 = ?"]
        case .medium:
            return ["220 + 257 = ?", "89 + 98 = ?"]
        case .hard:
            return ["220 * 250 = ?", "17 / 11 = ?"]
        }
    }()
}

var questtion = Exam(level: .medium)  //Must be var
var question2 = questtion
print("Wait for 5 second")
question2.level = .hard
print(questtion.questionExam)
print(question2.questionExam)
*/

/*extension init
struct Student {
    var firstName: String
    var middleName: String
    var lastName: String
}

extension Student {
    init(firstName: String, middleName: String) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = ""
    }
}

let student1 = Student(firstName: "Tien", middleName: "Viet")
let student2 = Student(firstName: "Viet", middleName: "Tien", lastName: "Trinh")
*/

/*ConvinentInit
class Student {
    var firstName: String
    var middleName: String
    var lastName: String
    
    init(firstName: String, middleName: String, lastName: String) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
    }
    
    convenience init(firstName: String, lastName: String) {
        self.init(firstName: firstName, middleName: "", lastName: lastName)
    }
}

extension Student {
    convenience init(firstName: String, middleName: String) {
        self.init(firstName: firstName, middleName: "", lastName: "")
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = ""
    }
}


let student1 = Student(firstName: "Viet", lastName: "Trinh")
let student2 = Student(firstName: "Viet", middleName: "dz")
*/


/* Subclass Init
class Student {
    var firstName: String
    var middleName: String
    var lastName: String
    
    init(firstName: String, middleName: String, lastName: String) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
    }
    
    convenience init(firstName: String, lastName: String) {
        self.init(firstName: firstName, middleName: "", lastName: lastName)
    }
}

class SubStudent: Student {
    var age: Int
    
    override init(firstName: String, middleName: String, lastName: String) {
        self.age = 23
        super.init(firstName: firstName, middleName: middleName, lastName: lastName)
    }
}

var subStudent = SubStudent(firstName: "Kaka", lastName: "HIH")
*/


