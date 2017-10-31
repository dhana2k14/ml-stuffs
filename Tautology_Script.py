
#!/usr/bin/env python
# importing the binary search tree class library 'TreeNode'
# Specifying the logical operators to work with 

from searchTree import TreeNode
OPERATORS = ('&', '|', '!')

# Checking whether the given statement is close bracket or not, 
# returns True or False

def isCloseBracket(q):
    return q == ')'

# Checking whether the given statment is an Operand, passing only a and b 
# according to the input statments given

def isOperand(q):
    return (q >= 'A' and q <= 'B') or (q >= 'a' and q <= 'b')

def notOp(x):
    return "!{}".format(x)


def orOp(y, z):
    if y == z:
        return y
    if isinstance(y, type('str')) and isinstance(z, type('str')):
        if len(y) > len(z) and len(z) == 1 and y == '!{}'.format(z):
             return True
        if len(y) < len(z) and len(y) == 1 and z == '!{}'.format(y):
             return True
        return '{}|{}'.format(y, z)


def andOp(y, z):
    if y == z:
        return y
    if isinstance(y, type('str')) and isinstance(z, type('str')):
        if len(y) > len(z) and len(z) == 1 and y == '!{}'.format(z):
             return False
        if len(y) < len(z) and len(y) == 1 and z == '!{}'.format(y):
             return False
        return '{}&{}'.format(y, z)


# Convert infix expressions into postfix expressions

def infixToPostfix(infix):
    top = -1
    precedence = {'!': 3, '&' : 2, '|' : 2, '(' : 1}
    operatorstack = []
    postfix = ''
    for q in infix:
        if q in OPERATORS:
            if isCloseBracket(q):
                while operatorstack:
                    op = operatorstack.pop()
                    top -= 1
                    if op == '(':
                        break
                    postfix += op
            else:
                temp_top = top
                if q == '(':
                    operatorstack.append(q)
                else:
                    while temp_top > -1:
                        if operatorstack[temp_top] == '(':
                            break
                        if precedence[operatorstack[top]] >= precedence[q]:
                            postfix += str(operatorstack.pop())
                            top -= 1
                        temp_top -= 1
                    operatorstack.append(q)
                top += 1
        elif isOperand(q):
            postfix += q
    while operatorstack:
        postfix += str(operatorstack.pop())
        top -= 1
    return postfix
    
# This is to evaluate postfix expression 
    
def postfixToExprTree(postfix):
    exprTreeStack = []
    for e in postfix: 
        node = TreeNode(e)
        if e in OPERATORS:
            if e == '!':
                node.left = exprTreeStack.pop()
            else:
                node.right = exprTreeStack.pop()
                node.left  = exprTreeStack.pop()
        exprTreeStack.append(node)
    root = exprTreeStack.pop()
    return root    


# This is to evaluate the expressions using expression tree
# Algorithm

def preEvaluate(root):
    if root:
        value = root.data
        if isOperand(value):
            return value
        left = preEvaluate(root.left)
        if value == '!': 
            return notOp(left)
        elif value == '&' and isinstance(left, type(True)) and not left:
            return False
        elif value == '|' and isinstance(left, type(True)) and left:
            return True
        right = preEvaluate(root.right)
        if value == '&':
            return andOp(left, right)
        elif value == '|':
            return orOp(left, right)
        return True
    return True


# To test and verify
# statement takes the input  

if __name__ == '__main__':
    statement = '(!a|(a & a))'
    print (statement)
    postfix = infixToPostfix(statement)
    print (postfix)
    root = postfixToExprTree(postfix)
    print (preEvaluate(root))
    
if __name__ == '__main__':
    statement = '(!a|(b & !a))'
    print (statement)
    postfix = infixToPostfix(statement)
    print (postfix)
    root = postfixToExprTree(postfix)
    print (preEvaluate(root))    
    
if __name__ == '__main__':
    statement = '(!a | a)'
    print (statement)
    postfix = infixToPostfix(statement)
    print (postfix)
    root = postfixToExprTree(postfix)
    print (preEvaluate(root))    
    
if __name__ == '__main__':
    statement = '((a & (!b|b))|(!a&(!b|b)))'
    print (statement)
    postfix = infixToPostfix(statement)
    print (postfix)
    root = postfixToExprTree(postfix)
    print (preEvaluate(root))    
    
