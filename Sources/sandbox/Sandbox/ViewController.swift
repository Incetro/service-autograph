//
//  ViewController.swift
//  Sandbox
//
//  Created by incetro on 3/25/21.
//

import UIKit
import Monreau
import HTTPTransport

class ViewController: UIViewController {

    private let userService: UserService = UserServiceGeneratedImplementation(
        dao: UserDAO(
            storage: RealmStorage<UserModelObject>(),
            translator: UserTranslator(configuration: RealmConfiguration())
        ),
        transport: HTTPTransport()
    )

    private let queue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        queue.maxConcurrentOperationCount = 1
        print("Call userService.obtain() asynchronously...")
        userService.obtain().async().success { [weak self] users in
            guard let self = self else { return }
            do {
                let localUsers = try self.userService.read().sync().get().sorted {
                    $0.id < $1.id
                }
                let users = users.sorted {
                    $0.id < $1.id
                }
                guard localUsers == users else {
                    fatalError("Something went wrong. Two users array should be equal")
                }
                print("Two arrays (from the database and network) are equal. We can continue.")
                self.syncCalls()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    private func syncCalls() {
        addOperation {
            let userId = 3
            print("Obtain user with id \(userId)... [sync]")
            let user = try self.userService.obtain(userId: userId).sync().get()
            print("User has been successfully obtained:")
            dump(user)
        }
        addOperation {
            let city = "Howemouth"
            print("Obtain users in city \(city)... [sync]")
            let users = try self.userService.obtain(inCity: city).sync().get()
            print("Users has been successfully obtained:")
            dump(users)
        }
        addOperation {
            print("Obtain users with (faked) pagination:")
            let users = try self.userService
                .obtain(page: 1, pageSize: 10)
                .sync()
                .get()
            print("Users has been successfully obtained:")
            dump(users)
        }
        addOperation {
            let user = UserPlainObject(
                id: 11,
                name: "Andrew",
                username: "incetro",
                email: "incetro@ya.ru",
                phone: "+79880111313",
                website: "incetro.com",
                address: AddressPlainObject(
                    street: "Beautiful street",
                    suite: "Some suite",
                    city: "Some city",
                    zipcode: "111313"
                ),
                company: CompanyPlainObject(
                    name: "Incetro Inc.",
                    catchPhrase: "Some catch phrase"
                )
            )
            print("Create user [sync]:")
            dump(user)
            let newUser = try self.userService.create(user: user).sync().get()
            print("Created user:")
            dump(newUser)
            guard user == newUser else {
                fatalError("Users must be equal here!")
            }
            print("Users are equal, everything is OK.")
        }
        addOperation {
            let userId = 5
            let name = "Frank"
            print("Update user's(\(userId)) name: \(name)... [sync]")
            let user = try self.userService
                .update(userId: userId, name: name)
                .sync()
                .get()
            guard user.name == name else {
                fatalError("Something went wrong: name should be equal to \(name) but got: \(user.name)")
            }
            print("User has been successfully updated:")
            dump(user)
        }
        addOperation {
            let userId = 7
            print("Delete the user with id = \(userId)")
            self.userService.delete(userId: userId).sync()
            let localUser = try self.userService.read(userId: userId).sync().get()
            guard localUser == nil else {
                fatalError("Local user must be nil after deleting!")
            }
            print("Local user is nil after deleting. Everything is OK.")
        }
        addOperation {
            print("There is a simple run through database methods:")
            print("Regular `read`:")
            print(try self.userService.read().sync().get())
            print("Read by userId:")
            dump(try self.userService.read(userId: 1).sync().get() as Any)
            print("Read by userIds:")
            dump(try self.userService.read(userIds: [2, 3]).sync().get())
            print("Erase by userId..")
            self.userService.erase(userId: 1).sync()
            dump(try self.userService.read().sync().get())
            print("Erase by userIds..")
            self.userService.erase(userIds: [2, 3]).sync()
            dump(try self.userService.read().sync().get())
            print("Erase all local objects..")
            self.userService.erase().sync()
            print("Local database was cleared.")
            exit(0)
        }
    }

    private func addOperation(_ closure: @escaping () throws -> Void) {
        queue.addOperation {
            do {
                print()
                try closure()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
