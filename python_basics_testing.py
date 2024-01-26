X = 1
Y = "HELLO_WORLD"
if X > 2:
    print("Six is greater than two!")
else: 
    print("cows are silly")

"""
testing multi
line comments
for python as
it is duffernt
than c
"""
print("hehe")
print(X,Y)


######################
#####################

a = str(3) #a is '3'
b = int(3) #b is 3
c = float(3) #c is 3.0 / double in other languages

print(type(a))
print(type(b))
print(type(c))

#####################
#####################

d = "Cows"
#this is the same in python as:
e = 'Cows'

#####################
#####################

f = 4
f = 'mops' #f has been overwritten

#####################
#####################

var1 = "John"
var1 = 'John'
var_1 = "John"
#same as other languages... no spaces in var names

#####################
#####################

g,h,i = "puppy", "kitten", "squid"
j,k,l = 'red', 'green', 'blue'
#m,n,o = bla, mah, rah --> cannot do this
p,q,r = 2,3,4

#####################
#####################

s = t = u = "qwerty"
print(s,t,u)

#####################
#####################

#collection / tuple 
fruits = ["grape","pear","crapple"]
(v,w,x) = fruits #note: ()
print(v,w,x)
(v,*w) = fruits #note: () and * in front of var
print(v,w)
fruits2 = ["grape","pear","crapple","sweet_thing","orange"]
(one, *two, three) = fruits2
print(one, two, three)

truple_test = ("grape","pear","crapple","sweet_thingsssssssss","orange") #note: () and not []
for m in truple_test: #note: the ":"
    print(m)
for i in range(len(truple_test)): #note: the ":"
    print(truple_test[i]) #note: [] and not ()
print("third entry is: ",truple_test[2])

temp = 0
while temp < len(truple_test):
    print(truple_test[temp]," woot: temp is = ", temp)
    temp = temp + 1

#####################
#####################

#output testing
moo = "COOWWW"
print("what moos?!? " + moo)
bird = " caw caw "
print(moo + bird) #note, must be same var type

x = 5
y = 10
print(x+y) #plus here acts as math op.... why?

#####################
#####################

#global vars
global_var = "earth"
def func_1(): #note the :
    print("where do we live? " + global_var)

func_1()

x = "test"
def func_2():
    x = "exam" #overwrites global x
    print(x)

func_2()

def func_3():
    global yesss
    yesss = "the_world"

#print(yesss,"help") #note: this would fail to be global if called before func called
func_3()
print(yesss)

x = "this_ham"
def func_4():
    global x
    x = "this_beef"

func_4()
print(x)
    
#####################
#####################

#data types:
#text = str
x = "Hello World"
print(type(x))

car = """a red car sped past me
today on the highway
they might have been late!"""
print(car)
print(car[4])

for k in car:
    print(k)

print("late" in car, " for if late is in 'car'")
print("weikwier" in car, " for if weikwier is in 'car'")

if "red" in car:
    print("yes, it's there")

if "ekdsfkjdsf" not in car:
    print("nooope!")

print(car[14:23])
print(car[:26])
print(car[-15:-35])

mew = "      Hello, again Mr Toad"
print(mew.upper())
print(mew.lower())
print(mew.strip())
print(mew.replace("l", "sSFD"))
print(mew.split("l"))

x = "pew pew"
y = "yew ywe"
z = x + "...." + y
print(z)

age = 99
msg = "My name is Craig, I am " + str(age)
print(msg)
msg2 = "My name is Craig, I am {}"           ###format automatically casts type, {} is a placeholder
print(msg2.format(age))
name = "Mufasa"
homes = 12938
msg3 = "My name is {}. I am {} years old and have lived in {} places"
print(msg3.format(name,age,homes))
msg4 = "My name is {1}. I am {0} years old and have lived in {2} places"
print(msg4.format(age,name,homes))

msg5 = "He said he was \"sorry\", but he lied" #note: \" msg \" escapes the marks and treats as string
print(msg5)

msg6 = "fun with \\ , eh"
print(msg6)

msg7 = "fun with\n, ehsdfsd"
print(msg7)

msg8 = "fun with\t, ehsdfsd"
print(msg8)

msg9 = "fun \rwith, ehsdfsd"
print(msg9)

msg10 = "fun with,\beh"
print(msg10)

msg11 = "\145\146\147\148"
print(msg11)

msg12 = "\x145\x146\x147\x148"
print(msg12)

msg_test = "happy is the one \twho \tfinds \tTickTacks fin finds finds finds"
print(msg_test.capitalize())
print(msg_test.casefold())
print(msg_test.center(22))
print(msg_test.count("finds"))
print(msg_test.encode())
print(msg_test.endswith("track"))
print(msg_test.expandtabs(9))
print(msg_test.find("who"))
print(msg_test.index("one"))
print(msg_test.isalnum())
print(msg_test.isalpha())
print(msg_test.isdecimal())
print(msg_test.isdigit())
print(msg_test.isidentifier())
print(msg_test.islower())
print(msg_test.isnumeric())
print(msg_test.isprintable())
print(msg_test.isspace())
print(msg_test.istitle())
print(msg_test.isupper())
test_tuple = ("mike", "hans", "peter")
print('!!'.join(test_tuple))
y = "MONKEY!!"
print(y.ljust(50), "is loose again")
print(y.lower())
y = "               tope                        "
print(y.lstrip())
y = "sd sd sd sd tope sd sd sd sd"
print(y.lstrip("sd"))

y = "       SELLO SSSSSAAAAMMMMMM SOUT SAPPY SILLY\n SHEEPS SOUT SOUT MINK SOUT MOO CAW GOES MOO"
mytable = y.maketrans("S","P")             ### could use to translate IP addresses for new tines or changing vpn?
print(y.translate(mytable))
print(y.partition("SOUT"))              ### creates tuple of str, seperating at first occurance of word
print(y.rpartition("SOUT"))             ### creates tuple of str, seperating at last occurance of word     
print(y.replace("SOUT","CAMP"))
print(y.rfind("SOUT"))
print(y.rindex("CAW"))
print(y.strip())
print(y.splitlines())
print(y.swapcase())

#### NOTE: r_function_name seems to do last case of everything (to the most right)

kk = "moosdfdsfdso"
print(kk.rjust(20, "O"))
print(kk.zfill(150))

#####################
#####################

#numbers = int,float,complex(i or j for imaginary numbers)
x = 5        ###int
print(type(x)) 
x = 5.5      ###float
print(type(x)) 
x = 5j+5     ###complex
print(type(x))
 
import random
print(random.randrange(5,9))
random.seed()
#print(random.getstate())

#####################
#####################

#seq = list,truple,range
###list
x = ["apple","crab","tree"]     
print(type(x)) 
print(x[0])
x.append("grape")
print(x)
y = x.copy()
print(y)
y.clear()
print(y)
y = x.copy()
print(y)
y.extend(x)
print(y)
print(y.index("crab"))
y.insert(1,"cow")
print(y)
y.pop(1)
print(y)
y.remove("apple")
print(y)
y.sort()
print(y)
y.reverse()
print(y)

for x in y:
    print(x)

o = 0
while o < len(y):
    print(y[o])
    o += 1
    print(o)

#============================================================================================
#============================================================================================
#########
##List comprehension / shorthand ####
## newlist = [expression for item in iterable if condition == True]
#########

######### note the one line application: initializes x, loops through every x in y,
######### and states if x is not equal to "apple" add to / keep in y
y = [x for x in y if x != "apple"]       
print(y)

[print(x) for x in y]    ### this is a way to write shorthand for loops

fruits = ["banana", "orange", "peach", "grape", "starfruit"]
test_list = []

## before
for x in fruits:
    if "g" in x:
        test_list.append(x)

print(test_list)

## after

new_list = [x for x in fruits if "g" in x]
print(new_list)
##
merp = [1,3,6,9,13,7,3,7,4,9]
new_list = [x for x in range(14) if x not in merp]
print(new_list)

merp = [x.upper() for x in fruits]
print(merp)

merp = ["testing... testing here!!!" for x in fruits]
print(merp)

merp = [x if x != "orange" else "cow" for x in fruits]
print(merp)

########################
########################

list_test = list(("taco","beer","pizza"))
print(list_test)

listsss=list(y)
print(listsss)

## NOTE: upper case letters are sorted after lower:
## ex: ["test", "apple", "CAR"] would sort to ["apple","test","CAR"]
fruits. sort()
print(fruits)
fruits.sort(reverse = True)
print(fruits)

fruits = ["banana", "Orange", "peach", "Grape", "starfruit"]
fruits. sort()
print(fruits)
## to ugnote case when sorting, user str.lower as a key, this reads all strings in as lower case
fruits.sort(key = str.lower)
print(fruits)



merp = [1,3,6,9,13,7,3,7,4,9]
def test_func(a):
    return abs(a-10)
merp.sort(key = test_func)
print(merp)



###truple --> a collection that is ordered by index and unchangable / cannot add or remove once created
### must convert to list in order to change values, then convery back to tuple
x = ("apple","crab","tree")     
print(type(x))
sdf = tuple(("apple","crab","tree"))    #note the two ((  and ))
print(type(sdf))

#to create a truple with one item:
test = ("mango",) #note the comma.. it's needed for some reason

if "crab" in sdf:
    print("si!")

### must convert to list in order to change values, then convery back to tuple
asd = list(sdf)
asd[1] = "post"
sdf = tuple(asd)
print(sdf)

(green,pink,yellow) = sdf    ## this unpacka the tuple into the elements, as listed, their index is equal to that... green --> sdf[1], pink --> sdf[2] ,ect
print(green)
print(pink)
print(yellow)
## NOTE: the number of unpacking variables, must match the number of values in tuple, if not, you need an asterix
(green,*pink)=sdf ## gives an error w/o * ... ALSO NOTE THE * COMES BEFORE THE UNPACKING VAR NAME
print(green)
print(pink)

longer_tuple = ("apple","arm","leg","neck","foot","grape")
(green,*body,grape) = longer_tuple
print(green)
print(body)
print(grape)

for i in range(len(longer_tuple)):
    print(longer_tuple[i])

tuple1 = sdf + longer_tuple
print(tuple1)

tuple2 = sdf * 3
print(tuple2)
print(tuple2.count("apple"))
print(tuple2.index("apple"))   ### note only the first occurance is returned.



x = range(16)                   ###range
print(type(x))



print("gooo!!")
#####################
#####################

#mapping = dict
x = {"tree" : "apple", "type" : "crab"}
print(type(x))

new_dict = {
    "brand": "Levi",
    "model": "distressed",
    "fit": "relaxed",
    "fit": "straight"                    ### note: duplicate values will overwrite others
}

print(new_dict)
print(new_dict["brand"])
test = new_dict.get("model")
print(test)
test = new_dict.keys()
print(test)

new_dict["store"] = "target"
print(new_dict)

print(new_dict.values())

new_dict["store"] = "amazon"
print(new_dict)

x = new_dict.items()                            #items update when dict is updated
print(x)

new_dict["sex"] = "male"
print(x)

if "xsex" in new_dict:
    print("it's there bub!")
else:
    print("what are you talking about?!?")

new_dict.update({"city" : "LA"})
print(new_dict)

new_dict.pop("store")
print(new_dict)

print(new_dict.get("city"), "here's the city!!!")

new_dict.popitem()
print(new_dict)

del new_dict["brand"]
print(new_dict)

new_dict.clear()

del new_dict

test_dict = {
    "brand": "Levi",
    "model": "distressed",
    "fit": "relaxed",
    "color": "blue",
    "store": "amazon",
    "local_retail":"target",
    "price": "way too much"
}

for x in test_dict:
    print(x)

print("now look for the differnce, see it?!?")

for x in test_dict:
    print(test_dict[x])

print("            ")

for x in test_dict.keys():
    print(x)

print("\nnow look for the differnce, see it?!?\n")

for x in test_dict.values():
    print(x)

print("\nand now together\n")

for x,y in test_dict.items():
    print(x,y)

new_dict = test_dict.copy()
print(new_dict)

del new_dict

new_dict = dict(test_dict)
print(new_dict)

nested_dict = {
    "charlie" : {
        "type" : "pet",
        "species" : "dog",
        "mix" : "terrier"
    },
    "dickens" : {
        "type" : "pet",
        "species" : "cat",
        "mix" : "tabby"
    },
    "stash" : {
        "type" : "pet",
        "species" : "cat",
        "mix" : "white fluffy thing"
    }
}


print(nested_dict)
print("\n")

##

charlie = {
        "type" : "pet",
        "species" : "dog",
        "mix" : "terrier"
}

dickens = {
        "type" : "pet",
        "species" : "cat",
        "mix" : "tabby"
}

stashe = {
        "type" : "pet",
        "species" : "cat",
        "mix" : "poof ball"
}

pets = {
    "dog" : charlie,
    "cat1" : dickens,
    "cat2" : stashe
}

print(pets)



print("\n\nYOU ARE HERE!!!!!!!!!!!!!!!!!!!!!!!!\n\n")

#####################
#####################

#set = set,frozenset
# A set is a collection which is both unordered and unindexed.
# made with {}
# no duplicates allowed and will be ignored
x = {"apple", "crab", "tree"}                 ###set
print(type(x))

for y in x:
    print(y)
print("banana" in x) ## true or fale if "banana" is in set

x.add("poster_chikd")
print(x)

new_set = {"one","two","three","four"}
x.update(new_set)                ## updates the set / adds values, does not have to be a set, ex: you can add a list
print(x)

x.remove("poster_chikd")
print(x)

for a in new_set:
    x.discard(a)

print(x)    

set_3 = x.union(new_set)
print(set_3)

set_4 = {"one", "tree", "crap"}

set_3.intersection_update(set_4)
print(set_3)

set_5 = set_3.intersection(set_4)
print(set_5)

set_5.symmetric_difference_update(x)
print(set_5)

set_6 = set_5.symmetric_difference(x)
print(set_6)

set_7 = x.union(set_3,set_4,set_5,set_6)
print(set_7)

print(set_3.issubset(set_7))     # true if all items in set_3 are a subset of set_7

print(set_7.issuperset(set_3))   # true if all items in set_3 are in set_5

print(set_7.isdisjoint(set_3))   #true if no items in set_7 are present in set_3

del new_set



x = frozenset({"apple", "crab", "tree"})      ###frozenset
print(type(x))


#####################
#####################

#boolean = bool
x = True
print(type(x))
a = 20
b = 99
if b < a:
    print("a larger than b is true")
elif b == a:                                     #note: elif means else if ...
    print("a equal to b is true")
else:
    print("a greater than b is true")

print(bool("Hello"))                       ###note: seomthing will == true, while nothing will == false
print(bool("Hello" == "hello"))
print(bool(15))
bool("")                                   ###note: will == false

def test_func():
    return True
if test_func():
    print("Yes!")
else:
    print("NO!")

a = 20
print(isinstance(a, int))
print(isinstance(a, float))

#####################
#####################

#bin = bytes,bytearray,memoryview
x = b"mono_color"                     ###bytes
print(type(x))
x = bytearray(7)                      ###bytetype
print(type(x))
x = memoryview(bytes(8))              #memoryview
print(type(x))


#####################
#####################
#operators
a = 1
b = 2
c = a + b
d = a - b
e = a * b
f = a / b
g = a % b          
h = a ** b                  # a^b
i = a // b                  # floor division
a += 1                      # a = a + 1
a -+ 1                      # a = a - 1
a *= 3                      # a = a * 3
a /= 3                      # a = a / 3
a %= 3                      # a = a % 3
a //= 3                     # a = a // 3
a **= 3                     # a = a ** 3
set1 = {0,1,2,3}
set2 = {2,3,4,5}
print(set1 & set2)          # & with sets will print the intersection of the two sets
a = 2
a &= 3                      # convert a and 3 into binary numbers and where the 1's match up, you add those numbers
a |= 3                      # convert numbers into binary numbers and where either one has a 1, add as part of the number
a ^= 3                      # equal to a = a^3

#####################
#####################
#conditionals
a = 15
b = 15
if a >= b:
    print("a is >= b")
elif a == b:
    print(" a == b")
elif a != b:
    print("a != b")
else:
    print("what is b?!?!")

#now shorthand:
if a >= b: print("a is >= b")
elif a == b: print(" a == b")
elif a != b: print("a != b")
else: print("what is b?!?!")

print("tacos!") if a > b else print("no tacos :'(")

print("tacos!") if a > b else print("mac&cheese") if a == b else print("no tacos :'(")

aa = 15
bb = 8
cc =15

if aa > bb and aa > 15:
    print("tacos!")

print("beef") if aa > 14 and a == cc else print("none for you!")
print("beef") if aa > bb or aa >> cc else print("?????????")

if aa > 0:
    if aa > bb:
        print("yes, aa > bb")
    elif aa > cc:
        print("yes, aa > cc")
    else:
        print("aa is not greater than bb or cc")

if aa != bb:
    pass

#####################
#####################
#while loops:
temp = 1
while temp < 42:
    temp +=3.567
    if temp >= 31 and temp <= 32:
        print("gap achieved!!!!")
        break
    if temp >= 8 and temp <= 19:
        continue
    print(temp)
else:
    aa = 11123123123
    print("aa is no longer under control! ", aa)

for x in "this is something now":
    print(x)

foods = ["taco","pizza","stew","pasta","beef wellington","salad"]
for x in foods:
    print(x)
    if x == "stew":
        break

for x in foods:
    if x == "pasta":
        continue
    print(x)

for x in range(0, 90, 8):
    print(x)

def choosing_the_fruit(**fruit):
    print("the only right fruit is obviously: " + fruit["awesome"])

choosing_the_fruit(bad = "corn", wrong = "tomato", awesome = "orange")

def default_fruit(noms = "orange"):
    print("I like " + noms  + " the best")

default_fruit("lemon")
default_fruit("lime")
default_fruit()
default_fruit("apple")

def choosing_food(food):
    for x in food:
        print(x)

choosing_food(foods)

def going_through_recursion(rec):
    if(rec > 0):
        result = rec + going_through_recursion(rec - 1)
        print(result)
    else:
        result = 0
    return result

print("\testing recursion")
going_through_recursion(13)
print("\n")

#####################
#####################
#lambda --> call a scaffolding function 
del y
y = lambda a : a +10
print(y(6))

z = lambda a, b : a * b
print(z(4,6))

q = lambda a, b, c, d : a + b + c + d
print(q(1,2,3,4))

def test_func1(a):
    return lambda b : b * a

new_number = test_func1(10)
print(new_number(3))

new_number = test_func1(8)
print(new_number(8))

def my_funct(n):
    return lambda a : a * n
double_it = my_funct(2)
tripple_it = my_funct(3)

print(double_it(11))
print(tripple_it(11))


#####################
#####################
#classes
class test_class:
    merp = 4.429494
    
test_object = test_class()    #note the (), just like a funct
print(test_object.merp)

#more real world example
class Identity:
    def __init__(self, name, age, sex, gender, purpose):
        self.name = name
        self.age = age
        self.sex = sex
        self.gender = gender
        self.purpose = purpose
        
person1 = Identity("John", 23, "Male", "Heterosexual Male", "Gardener")
person2 = Identity("Jill", 42, "Female", "Homosexual Female", "") 
#note: if part not defined, will cause an error when printing out

print(person1.purpose)
print(person2.purpose)

#object
class new_person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
        
    def person_def(self):
        print("Hello, my name is " + self.name)
    
new_man = new_person("Jack", 43.53)
new_man.person_def()

#note self does note need to be named self, but is the first object named in the class and is used to access variables that belong to the class
#modifying class value

new_man.age = 2
print(new_man.age)
del new_man.age

try:
    hasattr(new_man, "age")
except NameError:
    print("new_man has the attr age")
else:
    print("new_man has not attr age")

#note: hasarrt looks at object or class to see if attr exists, great for error checking

del new_man

try:            #test if new_man exists and expecting nameerror, puts out a message
    new_man
except NameError:
    print("does not exist")
    
class new_Person:
    pass

#cannot define empty class, but can leave blank and add to it later, hence pass

new_Person.age = 12
print(new_Person.age)

#####################
#####################
#inheritance
#parent -> child

class pet:
    def __init__(self, name, species):
        self.name = name
        self.species = species
        
    def print_name_and_species(self):
        print(self.name, self.species)
        
y = pet("Ted", "cat")              #y inheritance gives name and species attr
y.print_name_and_species()         

#Note: The __init__() function is called automatically every time the class is being used to create a new object.

class new_pet(pet):
    def __init__(self, name, species, sex):
        pet.__init__(self, name, species)
        self.pet_sex = sex
        
    def greet_pet_owners(self):
        print("Wlecome, owners of", self.name, "How is your", self.pet_sex, self.species, "today?")
        
class new_new_pet(pet):                
    def __init__(self, name, species, sex):
        super().__init__(name, species)             
        #super function makes it so you don't have to call parent function by name
        self.pet_sex = sex
        
    def greet_pet_owners(self):
        print("Wlecome, owners of", self.name, "How is your", self.pet_sex, self.species, "today?")
        
hobble = new_pet("hobble","cat","male")
novel = new_new_pet("novel","dog","female")

hobble.greet_pet_owners()
novel.greet_pet_owners()        

#####################
#####################
#iterator
my_tuple = ("car", "truck", "suv")
my_iterator = iter(my_tuple)
print(next(my_iterator))
print(next(my_iterator))
print(next(my_iterator))

test_string = "testing"
myit = iter(test_string)
print(next(myit))
print(next(myit))
print(next(myit))
print(next(myit))
print(next(myit))
print(next(myit))


my_init = iter(test_string)  
#need to initialize outside of for loop... lest you get all the beginning letter * number of letters... (ask me how i know :P )

for x in test_string:
    print(next(my_init))
    


for x in test_string:
    print(x)
    
print("you're here!!!!")

class number_test:
    def __iter__(self):
        self.iter = 1
        return self
        
    def __next__(self):
        if self.iter <= 4:
            x = self.iter
            self.iter += 1
            return x
        else:
            raise StopIteration
        
test_class = number_test()
iterator_test = iter(test_class)

for x in iterator_test:
    print(x)

#####################
#####################
#scope

del x
x = 300
a = 250

def myfunc():
    global x
    x += 1

myfunc()

print(x)
print(x)
print(x)

#####################
#####################
#module
import module
import auf_wiedersehen
module.greeting("Joey")
auf_wiedersehen.bye_bye("Joey", "10 AM")
import module as moot
import platform

#using variables defined in module
a = module.person1["age"]
print(a)

b = moot.person1["country"]
print(b)

## using a built-in platform - look up more of these later.
c = platform.system()
print(c)
print(dir(platform))

#from lets you pull elements from module. use person1, not module.person1 when using from x import y
from module import person1
for x in person1:
    print(person1[x])    

#####################
#####################
#date
import datetime

z = datetime.datetime.now()
print(z)

last_date = datetime.datetime(2021,3,15)  #note 3 and not 03
print(last_date)

print(last_date.strftime("%a")) #	Weekday, short version
print(last_date.strftime("%A")) #	Weekday, full version
print(last_date.strftime("%w")) #   Weekday as a number 0-6, 0 is Sunday
print(last_date.strftime("%d")) #	Day of month 01-31
print(last_date.strftime("%b")) #   Month name, short version
print(last_date.strftime("%B")) #	Month name, full version
print(last_date.strftime("%m")) #	Month as a number 01-12
print(last_date.strftime("%y")) #	Year, short version, without century
print(last_date.strftime("%Y")) #	Year, full version
print(last_date.strftime("%H")) #	Hour 00-23
print(last_date.strftime("%I")) #   Hour 00-12
print(last_date.strftime("%p")) #	AM/PM
print(last_date.strftime("%M")) #	Minute 00-59
print(last_date.strftime("%S")) #	Second 00-59
print(last_date.strftime("%f")) #	Microsecond 000000-999999
print(last_date.strftime("%j")) #   Day number of year 001-366
print(last_date.strftime("%U")) #	Week number of year, Sunday as the first day of week, 00-53
print(last_date.strftime("%W")) #	Week number of year, Monday as the first day of week, 00-53
print(last_date.strftime("%c")) #	Local version of date and time
print(last_date.strftime("%x")) #	Local version of date
print(last_date.strftime("%X")) #	Local version of time (if using timezone)
print(last_date.strftime("%%")) #	A % character
print(last_date.strftime("%G")) #	ISO 8601 year
print(last_date.strftime("%u")) #	ISO 8601 weekday (1-7)
print(last_date.strftime("%V")) #	ISO 8601 weeknumber (01-53)

#####################
#####################
#math
min_of = min(5, 50, 200, 3, 2345, 3, 56)
max_of = max(5, 50, 200, 3, 2345, 3, 56)
print(min_of)
print(max_of)

# reference https://www.w3schools.com/python/module_math.asp for the rest

#####################
#####################
#json
import json

person = '{"name":"Mike","age":"46","highest_education":"masters","region":"midwest","state":"Michigan","city":"Detroit","time_zone":"EST","field":"avionics"}'
candidate = json.loads(person) #parse person into python dictionary called candidate
print(candidate["city"])

person2 = {
    "name":"Kam",
    "age":"41",
    "highest_education":"Associates",
    "region":"southwest",
    "state":"Florida",
    "city":"Tampa",
    "time_zone":"GMT-4",
    "field":"Buss Driver"
}

candidate2 = json.dumps(person2) #convert python object to json string
print(candidate2)

print(json.dumps({"name": "Bobby", "age": 34})) #dict --> json object
print(json.dumps(["carrot", "celery"])) #list --> json array
print(json.dumps(("cherry", "apple"))) #tuple --> json array
print(json.dumps("hello")) #str --> json string
print(json.dumps(42)) #int -->json number
print(json.dumps(31.76)) #float --> json number
print(json.dumps(True)) #True --> json true
print(json.dumps(False)) #False --> json false
print(json.dumps(None)) #None --> json null


print(json.dumps({"name": "Bobby", "age": 34}, indent=14)) # can also use json.dumps to indent the python going into json string
print(json.dumps(person2, indent=6, separators=("...", " == "))) #separators changes the seperators to ... instead of , and == instead of :       // still not 100% sure as to why this order
print(json.dumps(person2, indent=6, separators=("...", " == "), sort_keys=True)) #sort_keys puts things in alphabetical order

#####################
#####################
#RegEx 
import re

#Metacharacters
# [] --> set of characters
#### [the] --> returns match if one of 't', 'h', or 'e' are present
#### [h-t] --> returns match if any lowercase character is in string between 'h' and 't'
#### [^the] --> returns match for any character except 't','h', or 'e'
#### [123] --> returns match if string contains 1,2,3
#### [0-9] --> returns match if contains any digit 0-9
#### [0-5][0-9] --> returns match for any two digit numbers 00-59
#### [a-zA-Z] --> returns match for any char between 'a'-'z' upper or lower case
#### [+] --> returns match for any + char in string (math symbols don't have meaning here, just '+' is a '+')
# \ --> signals a special sequence
#### \A --> returns match if chars are at the start of the string ex: "\ATHE" would be true if THE was the start of the string
#### \b is used as r"\bain" to see if a word begins with ain
#### \b also used for r"ain\b" to see if a word ends with ain
#### \B is used like \b but not matching ending or beginning words with string
#### \d --> returns a match for int digits 0-9 (splits into individual numbers / 099 goes to ['0','9','9'] )
#### \D is used like \d but for not matching for digits
#### \s used to return where string contains whitespace
#### \S is used like \s but for not matching for whitespace
#### \w is used to return a match where string contains and words or digits 0-9
#### \W is used like \w but not containing words or digits 0-9
#### \Z is used to return a match is characters are at end of string
# . --> searches for sequence in string where '.' is a wildcard ... ex: string is txt = "poppy seeds"  searched for with re.search(".py", txt) would match for 'poppy'
# ^ --> see if string starts with   --> NOTE: not word, the whole string
# $ --> see if string ends with     --> NOTE: not word, the whole string
# * --> zero or more occurrences  
# + --> one or more occurrences
# {} --> exactly the number of specified occurrences ... ex: "me{3}" would match for "men do not mean to meander"
# | --> either or match .... ex: "moo|fox" would match for "what does the fox say??!!"

txt = "how many people will have to read what is" 
x = re.search("^how.*is$", txt) #checks to see if the string starts with how and ends with written
print(x)  #will print out that there is a match, as well as give the range.

if x:
    print("YEP")
else:
    print("nope")

txt2 = "how many how much how few how long how high"
a = re.findall("how", txt2) # prints all matches found
print(a)
b = re.findall("hot", txt2) # prints all matches found (no matches found, so will print [] )
print(b)

c = re.search("\s", txt2) #returns first match for whitespace in json string
print(c)
print("first whitespace found at:", c.start()) #beginning of whitespace
print("first whitespace found at:", c.end())   #end of whitespace


d = re.split("\s", txt2) #will split at every instance of the given value, in this case whitespace
print(d)

e = re.split("\s",txt2, 4) #will only split at the first 4 occurrences of whitespace
print(e)

f = re.sub("how", "HOW", txt2) #subistitutes the 2nd value given for the first --> 'HOW' replaces how'
print(f)

g = re.search(r"\bh\w+",txt2)
print(g)
print(g.span())
print(g.string)
print(g.group())

#####################
#####################
#pip 

import sys
import subprocess
subprocess.check_call([sys.executable, '-m', 'pip', 'install', '--upgrade', 'pip'])
subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'camelcase'])

import camelcase
a = camelcase.CamelCase()
txt = "moo moo the cow!"
print(a.hump(txt))

subprocess.check_call([sys.executable, '-m', 'pip', 'uninstall', 'camelcase', '-y'])
subprocess.check_call([sys.executable, '-m', 'pip', 'list'])
#process = subprocess.Popen(['powershell','wget','-O','-https://pypi.org/simple/'])

#####################
#####################
#try except finally 

del x
try:
    print(x)
except:
    print("not defined!")
    
x = 12
try:
    print(x)
except:
    print("not defined!")
    
del x
try:
    x = x+1
except:
    print("something is wrong")
else:
    print("nothing to see here")
 
x=5 
try:
    x = x+1
except:
    print("something is wrong")
else:
    print("nothing to see here")
    
try:
    x = x+1
except:
    print("something is wrong")
finally:
    print("nothing to see here... please move on")
    
#### raising en exception ends the programs with a callback to the line and output specified 

#if x < 100000000000:
#    raise Exception("sorry mate, x is less than what we wanted")
    
x = 5
print(type(x))
#if not type(x) is str:
#    raise Exception("not a str!!!")

#####################
#####################
#user input

#user = input("Who are you? ")
#print("you say you are " + user)

#pip_package_to_install = input("What python package do you want to install? ")
#subprocess.check_call([sys.executable, '-m', 'pip', 'install', pip_package_to_install])
#subprocess.check_call([sys.executable, '-m', 'pip', 'uninstall', pip_package_to_install, '-y'])

#####################
#####################
#string formatting
#{} can act as a filler space in a string
place = "alaska"
time = "summer"
cost = 354
txt = "I want to go to {} during the {} if flights cost less than {:.2f} dollars"
print(txt.format(place,time,cost))

# see https://www.w3schools.com/python/ref_string_format.asp for more string formatting options

#####################
#####################
#file handling

file = open("test.txt", 'a')
file.write("testing testing, testing here!\n\n\n\n\n\n\n\n\n")
person2 = {
    "name":"Kam",
    "age":"41",
    "highest_education":"Associates",
    "region":"southwest",
    "state":"Florida",
    "city":"Tampa",
    "time_zone":"GMT-4",
    "field":"Buss Driver"
}
candidate2 = json.dumps(person2)
file.write(candidate2)
file.write("hello again")
file.write("not yet \n")
#file.close()
file = open("test.txt", 'r')
print(file.read())
print(file.readline())
print("\n\n")
print("you've made it")

file.close()
file = open("test.txt", 'r')
for x in file:
    print(x)
    print("new line here")


##EOF