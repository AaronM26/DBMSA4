import SwiftUI
import Network
import Foundation

struct Student: Identifiable, Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var email: String
    var enrollmentDate: String  // Now a String

    enum CodingKeys: String, CodingKey {
        case id = "student_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case enrollmentDate = "enrollment_date"
    }
}


struct ContentView: View {
    @State private var students: [Student] = []
    @State private var newStudentFirstName: String = ""
    @State private var newStudentLastName: String = ""
    @State private var newStudentEmail: String = ""
    @State private var newStudentEnrollmentDate: Date = Date()
    @State private var studentIdToUpdate: Int = 0
    @State private var newEmail: String = ""
    @State private var studentIdToDelete: Int = 0
    @State private var serverResponse: String = ""
    
    var body: some View {
        NavigationView {
                    Form {
                        Section(header: Text("All Students")) {
                            Button("Fetch All Students", action: getAllStudents)
                            ScrollView {
                                                    Text(serverResponse) // Display the formatted server response here
                                                        .font(.system(.body, design: .monospaced)) // Using monospaced font for better formatting
                                                }
                }
                
                Section(header: Text("Add Student")) {
                    TextField("First Name", text: $newStudentFirstName)
                    TextField("Last Name", text: $newStudentLastName)
                    TextField("Email", text: $newStudentEmail)
                    DatePicker("Enrollment Date", selection: $newStudentEnrollmentDate, displayedComponents: .date)
                    Button("Add Student", action: addStudent)
                }
                
                Section(header: Text("Update Student Email")) {
                    TextField("Student ID", value: $studentIdToUpdate, formatter: NumberFormatter())
                    TextField("New Email", text: $newEmail)
                    Button("Update Email", action: updateStudentEmail)
                }
                
                Section(header: Text("Delete Student")) {
                    TextField("Student ID", value: $studentIdToDelete, formatter: NumberFormatter())
                    Button("Delete Student", action: deleteStudent)
                }
            }
            .navigationBarTitle("Student Management")
        }
    }
    
    private func getAllStudents() {
          guard let url = URL(string: "http://localhost:3000/getAllStudents") else {
              print("Invalid URL")
              return
          }
          
          URLSession.shared.dataTask(with: url) { data, response, error in
              if let error = error {
                  DispatchQueue.main.async {
                      self.serverResponse = "Error: \(error.localizedDescription)"
                  }
                  return
              }
              guard let data = data else {
                  DispatchQueue.main.async {
                      self.serverResponse = "No data received"
                  }
                  return
              }

              // Attempt to format the JSON data
              if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                 let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                 let prettyString = String(data: prettyData, encoding: .utf8) {
                  DispatchQueue.main.async {
                      self.serverResponse = prettyString
                  }
              } else {
                  DispatchQueue.main.async {
                      self.serverResponse = "Unable to format data"
                  }
              }
          }.resume()
      }
    private func addStudent() {
        guard let url = URL(string: "http://localhost:3000/addStudent") else {
            print("Invalid URL")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let enrollmentDateString = dateFormatter.string(from: newStudentEnrollmentDate)

        let student = Student(
            id: 0,
            firstName: newStudentFirstName,
            lastName: newStudentLastName,
            email: newStudentEmail,
            enrollmentDate: enrollmentDateString  // Use the formatted date string
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(student)
            print("Request body set")
        } catch {
            print("Error encoding student: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding student: \(error)")
                return
            }
            self.getAllStudents()  // Refresh the student list
            print("Student added successfully")
        }.resume()
    }


    private func updateStudentEmail() {
        guard let url = URL(string: "http://localhost:3000/updateStudentEmail") else {
            print("Invalid URL")
            return
        }

        // Cast studentIdToUpdate to String
        let updateInfo: [String: String] = ["student_id": String(studentIdToUpdate), "new_email": newEmail]

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: updateInfo, options: [])
            print("Request body set")
        } catch {
            print("Error encoding update info: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error updating student email: \(error)")
                return
            }
            self.getAllStudents()  // Refresh the student list
            print("Email updated successfully")
        }.resume()
    }

    private func deleteStudent() {
        guard let url = URL(string: "http://localhost:3000/deleteStudent/\(studentIdToDelete)") else {
            print("Invalid URL")
            return
        }
        
        print("Deleting student with ID \(studentIdToDelete)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error deleting student: \(error)")
                return
            }
            getAllStudents()  // Refresh the student list
            print("Student deleted successfully")
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
