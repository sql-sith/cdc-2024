from cx_Freeze import setup, Executable

base = None    

executables = [Executable("diffie_hellman_idna.py", base=base)]

packages = ["idna"]
options = {
    'build_exe': {    
        'packages': ["math", "calutils", "primePy", "textwrap"]
    },    
}

setup(
    name = "diffie_hellman_idna",
    options = options,
    version = "0.1.2",
    description = 'calculating Diffie-Hellman in less than a week!',
    executables = executables
)