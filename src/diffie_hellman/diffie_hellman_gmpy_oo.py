# noinspection DuplicatedCode
# region docstring
"""
    Demonstration of the Diffie-Hellman algorithm, which allows two
    parties to publicly negotiate a private key in a secure manner.

    This variant is an object-oriented refactor of
    diffie_hellman_refactored_gmpy.py: the protocol steps are expressed
    as methods on a `Person` class, and the `__main__` block reads as a
    top-to-bottom transcript of the exchange.

    Protocol outline:

    1. Alice chooses g and p and sends them to Bob. Eve observes g and p.
       - They are called g and p, by the way, because you try to pick a
         value for p that is a huge prime number, and a value for g that
         can generate secrets that have mathematically desirable random
         attributes.
       - Selection of such g/p pairs is difficult, so some are actually
         published and people are encouraged to use them. It sounds crazy,
         but it works if your private keys are random and large.
    2. Alice chooses a secret number a and calculates A = (g^a) mod p and
       sends A to Bob. Eve observes A.
       - In this python script the secret number a will be called
         private_key_a and the number A will be called public_key_a.
    3. Bob chooses a secret number b and calculates B = (g^b) mod p and
       sends B to Alice. Eve observes B.
       - In this python script the secret number b will be called
         private_key_b and the number B will be called public_key_b.
    4. Alice calculates key = (B^a) mod p.
       - This is the shared secret that she and Bob will use to begin
         encrypting their communication.
       - In this python script, this shared secret will be called
         secret.
    5. Bob calculates key = (A^b) mod p.
    6. The values for key calculated by Alice and Bob are identical.
    7. Assuming Alice made good choices for g and p, it is not feasible
       for Eve to determine the value of key quickly enough to be useful.
"""
# endregion
# region imports
import secrets
from typing import Any
from gmpy2 import mpz, powmod, random_state, log2, mpz_urandomb
# endregion


# region constants
# values for (p)rime and (g)enerator are taken from the 2048-bit MODP Group  # noqa
# identified as group ID 14 in RFC 3526 (https://www.ietf.org/rfc/rfc3526.txt).

# PRIME in decimal: 32317006071311007300338913926423828248817941241140239112842009751400741706634354222619689417363569347117901737909704191754605873209195028853758986185622153212175412514901774520270235796078236248884246189477587641105928646099411723245426622522193230540919037680524235519125679715870117001058055877651038861847280257976054903569732561526167081339361799541336476559160368317896729073178384589680639671900977202194168647225871031411336429319536193471636533209717077448227988588565369208645296636077250268955505928362751121174096972998068410554359584866583291642136218231078990999448652468262416972035911852507045361090559  # noqa
PRIME: int = 0xFFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD129024E088A67CC74020BBEA63B139B22514A08798E3404DDEF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245E485B576625E7EC6F44C42E9A637ED6B0BFF5CB6F406B7EDEE386BFB5A899FA5AE9F24117C4B1FE649286651ECE45B3DC2007CB8A163BF0598DA48361C55D39A69163FA8FD24CF5F83655D23DCA3AD961C62F356208552BB9ED529077096966D670C354E4ABC9804F1746C08CA18217C32905E462E36CE3BE39E772C180E86039B2783A2EC07A28FB5C55DF06F4C52C9DE2BCBF6955817183995497CEA956AE515D2261898FA051015728E5A8AACAA68FFFFFFFFFFFFFFFF  # noqa
GENERATOR: int = 2
PRIVATE_KEY_BIT_LENGTH: int = 2048
SEED_BIT_LENGTH: int = 256
# endregion


def _generate_private_key(key_length: int = PRIVATE_KEY_BIT_LENGTH) -> mpz:
    rs = random_state(secrets.randbits(SEED_BIT_LENGTH))
    return mpz_urandomb(rs, key_length)


class Person:
    def __init__(self, name: str, partner_name: str):
        self._name = name
        self._partner_name = partner_name
        self._data: dict[str, Any] = {}

    @property
    def name(self) -> str:
        return self._name

    @property
    def partner_name(self) -> str:
        return self._partner_name

    def store_data(self, key: str, value: Any, announce: bool = True) -> None:
        self._data[key] = value
        if announce:
            print(f"{self._name} has learned the value of {key}.")

    def get_data(self, key: str) -> Any:
        return self._data[key]

    def broadcast(self, persons: list["Person"], key: str, value: Any) -> None:
        print(f"\nPublicly announcing the value of {key}.")
        for person in persons:
            if person is self:
                person.store_data(key, value, announce=False)
            else:
                print(f"Telling {person.name} the value of {key}.")
                person.store_data(key, value)
        print("")

    def choose_public_parameters(self, persons: list["Person"]) -> None:
        p = PRIME
        g = GENERATOR

        print("")
        print(f"The values for the (g)enerator is {g}. The value for the (p)rime is ... big. Here it is:")  # noqa
        print(f"{p}")
        print("")
        print(f"The size of the the prime is {log2(p)} bits.")

        self.broadcast(persons, "g", g)
        self.broadcast(persons, "p", p)

    def generate_keypair(self, persons: list["Person"], suffix: str) -> None:
        private_key = _generate_private_key()
        self.store_data(f"private_key_{suffix}", private_key, announce=False)
        print(f"\n{self._name} has chosen private key {private_key}.")
        print(f"The size of this private key is {log2(private_key)} bits.")

        g = self.get_data("g")
        p = self.get_data("p")

        public_key = powmod(g, private_key, p)
        print(f"\n{self._name} has generated public key {public_key}.")
        print(f"The size of this public key is {log2(public_key)} bits.")
        self.broadcast(persons, f"public_key_{suffix}", public_key)

    def compute_shared_secret(self, own_suffix: str, partner_suffix: str) -> None:
        secret = powmod(
            self.get_data(f"public_key_{partner_suffix}"),
            self.get_data(f"private_key_{own_suffix}"),
            self.get_data("p"),
        )
        self.store_data("secret", secret)

    def contemplates_life(self) -> None:
        self.store_data("her own self-esteem", "fully and permanently destroyed")

    def tell_all(self) -> None:
        print(f"\nHi, my name is {self._name}. Thanks for having me. Here's everything I know.")
        for key in sorted(self._data):
            print(f"  The value of {key} is {self._data[key]}.")


def show_what_everyone_knows(persons: list[Person]) -> None:
    for person in persons:
        person.tell_all()


def show_succinct_report(alice: Person, bob: Person) -> None:
    alice_secret = alice.get_data("secret")
    bob_secret = bob.get_data("secret")

    print("")
    print("BOTTOM LINE:")
    print("------------")
    print("Did Alice and Bob generate the same key?")
    print("")
    print(f"Alice's secret: {alice_secret}.")
    print(f"Bob's secret:   {bob_secret}.")
    print("")

    if alice_secret == bob_secret:
        print("Yep, they did.")
    else:
        print("No, they did not! This will be reported to my parole officer.")

    print("")


if __name__ == "__main__":
    alice = Person(name="Alice", partner_name="Bob")
    bob = Person(name="Bob", partner_name="Alice")
    eve = Person(name="Eve", partner_name="Slender Man")
    persons = [alice, bob, eve]

    alice.choose_public_parameters(persons)
    alice.generate_keypair(persons, suffix="a")
    bob.generate_keypair(persons, suffix="b")
    alice.compute_shared_secret(own_suffix="a", partner_suffix="b")
    bob.compute_shared_secret(own_suffix="b", partner_suffix="a")
    eve.contemplates_life()
    show_what_everyone_knows(persons)
    show_succinct_report(alice, bob)
