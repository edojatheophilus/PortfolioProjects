from tkinter import *
from tkinter import messagebox
from Tetris import Tetris
import Database as db

class UserInterface:

    def __init__(self):
        self.window = Tk()
        self.window.geometry("500x500")
        Label(self.window, text="Please enter details below", width="300", bg="orange",fg="white").pack()
        self.signInFrame = Frame(self.window, width=500, height=500)
        self.loginFrame = Frame(self.window, width=500, height=500)

    def userCredential(self,username, password):
        print("username entered :", username.get())
        print("password entered :", password.get())
        loginFlag = db.searchDB(username.get(),password.get())
        global g_username 
        g_username = username.get()
        if loginFlag:
            self.window.destroy()
            game = Tetris()
            game.main_menu()
        else:
            messagebox.showerror("Error", "Invalid User Name And Password")

    def userRegister(self,username,nickname,password,confirmPassword):
        newUsername = username.get()
        newNickname = nickname.get()
        newPassword = password.get()
        newConfirmPassword = confirmPassword.get()
        global g_username
        g_username = newUsername

        if newPassword.lower() != newConfirmPassword.lower():
            messagebox.showerror("Error", "Invalid User Name And Password")
        else:
            signInFlag = db.addUser(newUsername,newNickname,newPassword)
            self.window.destroy()
            game = Tetris()
            game.main_menu()
            

    def LoginPage(self):
        #username label and text entry box
        usr = Frame(self.loginFrame)
        usernameLabel = Label(usr, text="Username *").pack(side=LEFT)
        username = StringVar()
        usernameEntry = Entry(usr, textvariable=username).pack(side=LEFT)
        usr.pack(side=TOP,anchor=CENTER)  

        #password label and password entry box
        passw = Frame(self.loginFrame,pady=20)
        passwordLabel = Label(passw,text="Password *").pack(side=LEFT) 
        password = StringVar()    
        passwordEntry = Entry(passw, textvariable=password).pack(side=LEFT)
        passw.pack(side=TOP)

        #buttons
        loginButton = Button(self.loginFrame, text="Login", width=10, height=1, bg="orange", 
                             command=lambda : self.userCredential(username, password)).pack(pady=10) 
        signupButton = Button(self.loginFrame, text="Signup", width=10, height=1, bg="orange", 
                              command=self.SignInPage).pack()
        
        
        self.loginFrame.pack(pady=120)
        self.window.mainloop()

    def SignInPage(self):
        self.loginFrame.forget()
        
        #username label and text entry box
        usr = Frame(self.signInFrame)
        usernameLabel = Label(usr, text="Username *").pack(side=LEFT)
        username = StringVar()
        usernameEntry = Entry(usr, textvariable=username).pack(side=LEFT) 
        usr.pack(side=TOP,anchor=CENTER,pady=10)
        
        nck = Frame(self.signInFrame)
        nicknameLabel = Label(nck, text="Nickname *").pack(side=LEFT)
        nickname = StringVar()
        nicknameEntry = Entry(nck, textvariable=nickname).pack(side=LEFT)
        nck.pack(side=TOP,anchor=CENTER,pady=10)

        #password label and password entry box
        passw = Frame(self.signInFrame)
        passwordLabel = Label(passw,text="Password *").pack(side=LEFT) 
        password = StringVar()    
        passwordEntry = Entry(passw, textvariable=password, show='*').pack(side=LEFT)
        passw.pack(side=TOP,anchor=CENTER,pady=10)
        
        cfnm = Frame(self.signInFrame)      
        confirmPasswordLabel = Label(cfnm,text="Confirm *").pack(side=LEFT)  
        confirmPassword = StringVar()    
        confirmPasswordEntry = Entry(cfnm, textvariable=confirmPassword, show='*').pack(side=LEFT)
        cfnm.pack(side=TOP,anchor=CENTER,pady=10)

        loginButton = Button(self.signInFrame, text="Login", width=10, height=1, bg="orange",
                             command=lambda : self.userRegister(username,nickname,password,confirmPassword)).pack()
        
        self.signInFrame.pack(pady=100)     
