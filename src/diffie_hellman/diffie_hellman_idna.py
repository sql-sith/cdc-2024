# noinspection DuplicatedCode
"""
    Demonstration of the Diffie-Hellman algorithm, which allows two
    parties to publicly negotiate a private key in a secure manner.

    Here is the outline of what this program will do:

    1. Alice chooses g and p and sends them to Bob. Eve observes g and p.
    2. Alice chooses a secret number a and calculates A = (g^a) mod p and
       sends A to Bob. Eve observes A.
    3. Bob chooses a secret number b and calculates B = (g^b) mod b and
       sends B to Alice. Eve observes B.
    4. Alice calculates key = (B^a) mod p.
    5. Bob calculates key = (A^b) mod p.
    6. The values for key calculated by Alice and Bob are identical.
    6. Assuming Alice made good choices for g and p, it is not feasible
       for Eve to determine the value of key quickly enough to be useful.

"""

from math import gcd
# from random import randint
from calutils.strings import get_int_from_console
from primePy.primes import check as is_prime
from textwrap import fill, indent

MIN_PRIME = 10**4 - 1
MAX_PRIME = 10**50 - 1
MIN_GENERATOR = 2
MAX_GENERATOR = 10**20 - 1
MIN_PRIVATE_KEY = 10**4 - 1
MAX_PRIVATE_KEY = 10**15 - 1
INDENT_WIDTH = 100
INDENT_PREFIX = '  | '

EVALUATE_INPUT_QUALITY = True
# EVALUATE_SMALL_NUMBER_THRESHOLD: int = 1000000


class Person(object):
    _name: str
    _data: dict

    def __init__(self, name):
        self._name = name
        self._data = {}

    def store_data(self, key: str, value: any) -> None:
        self._data[key] = value

    def get_data(self, key: str) -> any:
        return self._data[key]

    def get_sorted_data_keys(self) -> list:
        return sorted(self._data)

    def get_name(self) -> str:
        return self._name

    def tell_all(self) -> None:
        print(f"\nHi, my name is {self.get_name()}. Thanks for having me. Here's everything I know.")

        for item in self.get_sorted_data_keys():
            print(f"  The value of {item} is {self.get_data(item)}")


def show_welcome_message() -> None:
    print("")
    msg = "This is your chance to be Alice and Bob! Supply values for g, p, and "\
          "each private key when prompted. From these, Python will calculate the"\
          "public keys and the shared secret and will display the results for you."
    print(indented_text(msg=msg, indent_width=INDENT_WIDTH))


def tell_everyone(key: str, value: any) -> None:
    print("")
    for person in persons:
        person.store_data(key, value)
        msg = f"{person.get_name()} has learned that {key} has the value {value}."
        print(indented_text(msg=msg, indent_width=INDENT_WIDTH, indent_prefix=INDENT_PREFIX))


def indented_text(msg: str, indent_width: int, indent_prefix: str = None) -> str:
    """
    Wraps line blocks of text for display, optionally adding a prefix to each line.

    Args:
        msg:           (str) The string to format.
        indent_width:  (int) The length desired for wrapped text (not including indent_prefix).
        indent_prefix: (str) An optional prefix to put at the beginning of each line

    Returns:           (str) The formatted string.

    """
    msg = fill(msg, width=indent_width)

    if indent_prefix:
        msg = indent(msg, prefix=indent_prefix)

    return msg


def evaluate_diffie_hellman_seeds(p: int, g: int) -> None:
    """
    Gives extremely rudimentary feedback on the quality of the parameters
    p and g as input parameters for the prime and generator variables in
    the Diffie-Hellman algorithm.

    Args:
        p: the (p)rime input for Diffie-Hellman
        g: the (g)enerator input for Diffie-Hellman

    Returns:
        Nothing. Prints information regarding the quality of the
        provided p and g inputs for Diffie-Hellman.

    """  # noqa
    print("\nBeginning quality evaluation of p and g.")
    msg = "This message is a reminder that when Diffie-Hellman or similar algorithms are used, the primes"\
          " involved are very large. I'll give an example of what \"very large\" means in another script."
    print(indented_text(msg=msg, indent_width=INDENT_WIDTH, indent_prefix=INDENT_PREFIX))
    print("")

    number_of_primes = 0
    print("")
    for var_name in ("p", "g"):
        var_value = locals()[var_name]
        if is_prime(var_value):
            number_of_primes += 1
            print(f"  | Well done! Your choice for {var_name} ({var_value}) is prime!")
        else:
            msg = f"Your choice for {var_name} ({var_value}) is not prime. This will "\
                  f"be discussed with your parole officer."
            print(indented_text(msg=msg, indent_width=INDENT_WIDTH, indent_prefix=INDENT_PREFIX))

    coprime = gcd(p, g) == 1  # noqa
    if not coprime:
        match number_of_primes:
            case 0:
                msg = "Neither p nor g are prime, and they are not co-prime. We'll "\
                      "continue, just to humor you."
                print(indented_text(msg=msg, indent_width=INDENT_WIDTH, indent_prefix=INDENT_PREFIX))
            case 1:
                msg = "You got one prime number at least. Greet your million Shakespeare monkeys "\
                      "monkeys for me when you get home."
                print(indented_text(msg=msg, indent_width=INDENT_WIDTH, indent_prefix=INDENT_PREFIX))
            case 2:
                msg = "How did you get_data two prime numbers that are not co-prime??!? I don't "\
                           "believe you exist."
                print(indented_text(msg=msg, indent_width=INDENT_WIDTH, indent_prefix=INDENT_PREFIX))
    else:
        match number_of_primes:
            case 0:
                msg = "Neither p nor g are prime, but at least they are co-prime. Do you think "\
                           "this makes you smarter than a fifth grader?"
                print(indented_text(msg=msg, indent_width=INDENT_WIDTH, indent_prefix=INDENT_PREFIX))
            case 1:
                msg = "You got a prime and a co-prime pair? Congratulations, you sound like a "\
                           "square dance."
                print(indented_text(msg=msg, indent_width=INDENT_WIDTH, indent_prefix=INDENT_PREFIX))
            case 2:
                msg = "Finally, somebody got this right. Thank you."
                print(indented_text(msg=msg, indent_width=INDENT_WIDTH, indent_prefix=INDENT_PREFIX))

    print("")


def alice_chooses_public_seeds_g_and_p():
    p = get_int_from_console(
        f"\nEnter a value for p (min: {MIN_PRIME}; max: {MAX_PRIME}):\n> ",
        MIN_PRIME, MAX_PRIME)
    g = get_int_from_console(
        f"\nEnter a value for g (min: {MIN_GENERATOR}; max: {MAX_GENERATOR}):\n> ",
        MIN_GENERATOR, MAX_GENERATOR)

    if EVALUATE_INPUT_QUALITY:
        evaluate_diffie_hellman_seeds(p, g)

    # share these values publicly:
    tell_everyone("g", g)
    tell_everyone("p", p)


def alice_chooses_private_key_a_and_calculates_public_key_a():
    private_key_a = get_int_from_console(
        f"\nEnter a value for private_key_a (min: {MIN_PRIVATE_KEY}; max: {MAX_PRIVATE_KEY}):\n> ",
        MIN_PRIVATE_KEY, MAX_PRIVATE_KEY)
    alice.store_data("private_key_a", private_key_a)

    g = alice.get_data("g")
    p = alice.get_data("p")

    public_key_a = (g ** private_key_a) % p
    tell_everyone("public_key_a", public_key_a)


def bob_chooses_private_key_b_and_calculates_public_key_b():
    private_key_b = get_int_from_console(
        f"\nEnter a value for private_key_b (min: {MIN_PRIVATE_KEY}; max: {MAX_PRIVATE_KEY}):\n> ",
        MIN_PRIVATE_KEY, MAX_PRIVATE_KEY)
    bob.store_data("private_key_b", private_key_b)

    g = bob.get_data("g")
    p = bob.get_data("p")

    public_key_b = (g ** private_key_b) % p
    tell_everyone("public_key_b", public_key_b)


def alice_calculates_the_shared_secret():
    secret = (alice.get_data("public_key_b") ** alice.get_data("private_key_a")) % alice.get_data("p")
    alice.store_data("secret", secret)


def bob_calculates_the_shared_secret():
    secret = (bob.get_data("public_key_a") ** bob.get_data("private_key_b")) % bob.get_data("p")
    bob.store_data("secret", secret)


def eve_is_like_whatever():
    eve.store_data("her darkest dream", "that they won't get away with this")


def show_what_everyone_knows() -> None:
    for person in persons:
        person.tell_all()

    print("\nBottom line:")
    msg = f"   Bob calculated a secret of {bob.get_data('secret')}, and"
    print(indented_text(msg=msg, indent_prefix=INDENT_PREFIX, indent_width=INDENT_WIDTH))
    msg = f" Alice calculated a secret of {alice.get_data('secret')}."
    print(indented_text(msg=msg, indent_prefix=INDENT_PREFIX, indent_width=INDENT_WIDTH))
    print("")


if __name__ == "__main__":
    alice = Person(name="Alice")
    bob = Person(name="Bob")
    eve = Person(name="Eve")
    persons = [alice, bob, eve]

    show_welcome_message()
    alice_chooses_public_seeds_g_and_p()
    alice_chooses_private_key_a_and_calculates_public_key_a()
    bob_chooses_private_key_b_and_calculates_public_key_b()
    alice_calculates_the_shared_secret()
    bob_calculates_the_shared_secret()
    eve_is_like_whatever()
    show_what_everyone_knows()
