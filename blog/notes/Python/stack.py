from queue import LifoQueue


def is_correct(row: str) -> bool:
    """
    Проверка скобочной последовательности: ()[]{}
    """
    # сущ. слуйчай за O1
    # сред. слуйчай O(n)
    if len(row) %2 != 0:
        return False

    stack = LifoQueue()

    for let in row:
        if let == "{":
            stack.put("}")
        elif let == "(":
            stack.put(")")
        elif let == "[":
            stack.put("]")
        else:
            if stack.empty():
                return False
            elem = stack.get()
            if elem != let:
                return False

    return stack.empty()


print(is_correct("([{}])[]{}"))  # True
print(is_correct("([)]"))  # False
print(is_correct("[{"))  # False
print(is_correct("))"))  # False
print(is_correct("))]"))  # False
