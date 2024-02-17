while True:
    x=int(input("Enter x number: "))
    if x<=0:
        print("Invalid x number. Number should have been a positive integer.")
    else:
        while True:
            y=int(input("Enter y number: "))
            if y<=0:
                print("Invalid y number. Number should have been a positive integer.")
            else:
                counter=1
                product=x
                while counter<y:
                    product=product*x
                    counter=counter+1
                else:
                    print(product)
                    break