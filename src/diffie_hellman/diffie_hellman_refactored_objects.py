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

# region constants
MIN_PRIME = 10**4 - 1
MAX_PRIME = 10**50 - 1
MIN_GENERATOR = 2
MAX_GENERATOR = 10**7 - 1
MIN_PRIVATE_KEY = 10**4 - 1
MAX_PRIVATE_KEY = 10**5 - 1
INDENT_WIDTH = 100
INDENT_PREFIX = '  | '

EVALUATE_INPUT_QUALITY = True
# endregion


class Person(object):
    _name: str
    _partner_name: str
    _data: dict

    def __init__(self, name, partner_name):
        self._name = name
        self._partner_name = partner_name
        self._data = {}

    def inform_everyone(self, key: str, value: any, scope_by_owner: bool = False) -> None:
        print("")
        for person in persons:
            if person is not self:
                suffix = f".{self._name}" if scope_by_owner else None
                person.store_data(key, value, suffix)
                msg = f"{person.get_name()} has learned that {key} has the value {value}."
                print(indented_text(msg=msg, indent_width=INDENT_WIDTH, indent_prefix=INDENT_PREFIX))

    def choose_named_value(
            self, name: str, prompt: str = None, min_value: int = 1, max_value: int = 10,
            is_public: bool = False, scope_by_owner: bool = False) -> int:

        if not prompt:
            # todo: add logic to include min and/or max values if provided
            prompt = f"Please enter a value for {name}:\n> "

        value = get_int_from_console(
            prompt,
            min_value,
            max_value)
        print(value)
        self.store_data(name, value)
        if is_public:
            self.inform_everyone(name, value, scope_by_owner=scope_by_owner)

        return value

    def generate_public_key(self):
        g = self.get_data("g")
        p = self.get_data("p")
        private_key = self.get_data("private_key")

        public_key = (g ** private_key) % p
        self.store_data(f"public_key.{self.get_name()}", public_key)
        self.inform_everyone(f"public_key.{self.get_name()}", public_key, scope_by_owner=True)

    def calculate_shared_secret(self):
        secret = ((
            self.get_data("public_key", scope_suffix=self._partner_name) ** self.get_data("private_key")) %
                 self.get_data("p"))
        self.store_data("secret", secret)

    def store_data(self, key: str, value: any, scope_suffix: str = None) -> None:
        if scope_suffix:
            key = f"{key}.{scope_suffix}"
        self._data[key] = value

    def get_data(self, key: str, scope_suffix: str = None) -> any:
        if scope_suffix:
            key = f"{key}.{scope_suffix}"
        return self._data[key]

    def get_all_data(self) -> dict:
        return self._data

    def get_sorted_data_keys(self) -> list:
        return sorted(self._data)

    def get_name(self) -> str:
        return self._name

    def tell_us_everything(self) -> None:
        print(f"\nHi, my name is {self.get_name()}. Thanks for having me. Here's everything I know.")

        for item in self.get_sorted_data_keys():
            print(f"  The value of {item} is {self.get_data(item)}")


def show_welcome_message() -> None:
    print("")
    msg = "This is your chance to be Alice and Bob! Supply values for g, p, and "\
          "each private key when prompted. From these, Python will calculate the"\
          "public keys and the shared secret and will display the results for you."
    print(indented_text(msg=msg, indent_width=INDENT_WIDTH))


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


def alice_chooses_g_and_p():
    _ = alice.choose_named_value(
        name="p",
        prompt=f"\nEnter a value for p (min: {MIN_PRIME}; max: {MAX_PRIME}):\n> ",
        min_value=MIN_PRIME,
        max_value=MAX_PRIME,
        is_public=True,
        scope_by_owner=False)

    _ = alice.choose_named_value(
        name="g",
        prompt=f"\nEnter a value for g (min: {MIN_GENERATOR}; max: {MAX_GENERATOR}):\n> ",
        min_value=MIN_GENERATOR,
        max_value=MAX_GENERATOR,
        is_public=True,
        scope_by_owner=False)


def choose_private_keys():
    for person in (alice, bob):
        _ = person.choose_named_value(
            name="private_key",
            prompt="Please enter a 5-digit private key.\n> ",
            min_value=MIN_PRIVATE_KEY,
            max_value=MAX_PRIVATE_KEY,
            is_public=False
        )


def generate_public_keys():
    for person in (alice, bob):
        person.generate_public_key()


def calculate_shared_secrets():
    for person in (alice, bob):
        person.calculate_shared_secret()


def eve_is_like_this_is_fine():
    eve.store_data("_her darkest dream_", "that they won't get away with this")


def what_did_everyone_learn_today() -> None:
    for person in persons:
        person.tell_us_everything()

    print("\nBottom line:")
    msg = f" Bob   calculated a secret of {bob.get_data('secret')}, and"
    print(indented_text(msg=msg, indent_prefix=INDENT_PREFIX, indent_width=INDENT_WIDTH))
    msg = f" Alice calculated a secret of {alice.get_data('secret')}."
    print(indented_text(msg=msg, indent_prefix=INDENT_PREFIX, indent_width=INDENT_WIDTH))
    print("")


if __name__ == "__main__":
    alice = Person(name="Alice", partner_name="Bob")
    bob = Person(name="Bob", partner_name="Bob")
    eve = Person(name="Eve", partner_name="The KGB")
    persons = [alice, bob, eve]

    show_welcome_message()

    alice_chooses_g_and_p()

    if EVALUATE_INPUT_QUALITY:
        evaluate_diffie_hellman_seeds(alice.get_data("p"), alice.get_data("g"))

    choose_private_keys()
    generate_public_keys()
    calculate_shared_secrets()

    eve_is_like_this_is_fine()
    what_did_everyone_learn_today()
