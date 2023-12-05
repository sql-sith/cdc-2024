""" String utilities. """
from math import inf


def get_int_from_console(prompt: str, _min: int, _max: int) -> int:
    """ Interactively prompts the console user for input and verifies that the input is an int.

    :type prompt: string   Prompt to show user on console.
    :type _min:      int   Minimum size of acceptable response. Use -inf to allow any minimum.
    :type _max:      int   Maximum size of acceptable response. Use -inf to allow any minimum.

    """
    done = False
    while not done:
        the_string = input(prompt)

        try:
            the_int = int(the_string)
        except ValueError:
            print(
                f"{the_string} is not an integer. Please enter an integer value between {_min} to {_max}."
            )
            continue

        if _min <= the_int <= _max:
            done = True
        else:
            print("Error - the integer must be between {} and {}!".format(_min, _max))

    return the_int
