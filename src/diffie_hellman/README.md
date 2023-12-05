# Diffie-Hellman Python Scripts

Two programs with naive implementations of the Diffie-Hellman protocol.

## Overview

There are two Python scripts in this directory:

1. `diffie_hellman.py` is an interactive Python script that will let you play the role of Alice in choosing the value of `p` (the prime number) and `g` (the "generator"). It will then give a (pretty lousy) assessment of your choices of `p` and `q` before proceeding to generate the remaining values for Alice and Bob's private keys and public keys, and using them to compute a shared secret.
2. `diffie_hellman_gmpy.py` automatically generates all the values: `p`, `g`, both private and public keys, and the shared secret. However, it does this using a full-size 2048-bit prime number (`p`) and its specified paired generator (`g`) from an Internet RFC. To facilitate doing this in a performant manner, an efficient mathematics library called `gmpy2` was used instead of the builtin Python math functions.

While the programs both make most, or all, of Alice and Bob's decisions automatically, they still are written in a way that traces Alice and Bob's activity as explained in the PDF in the `meeting notes` folder.

Both programs let you know whenever Alice, Bob, or Eve learn one of the numbers involved in the computations, and both also tell you what everyone knows at the end of the program.

## Using the Scripts

### Prerequisites

To run the scripts, first clone the repository or otherwise copy the `src` folder from the repository to your computer. 

1. In a terminal or `PowerShell` window, use `cd` to enter the `./src/diffie_hellman` folder.

   ```bash
   $ cd ./src/diffie_hellman
   ```

2. Ensure you are running `python` version 3.10.4 or later and the corresponding version of `pip`.

   ```bash
   $ python --version
   Python 3.10.4
   
   $ python -m pip --version
   pip 23.3.1 from /home/chris/.local/lib/python3.9/site-packages/pip (python 3.9)
   ```
3. There is a file in this folder called `requirements.txt` that `pip` can use to install the libraries required by these scripts. 

   ```bash
   $ python -m pip install -r .\requirements.txt
   Collecting primePy==1.3
   Using cached primePy-1.3-py3-none-any.whl (4.0 kB)
   Collecting gmpy2==2.1.5
     Using cached gmpy2-2.1.5-cp310-cp310-win_amd64.whl (1.1 MB)
   Installing collected packages: primePy, gmpy2
   Successfully installed gmpy2-2.1.5 primePy-1.3
   WARNING: You are using pip version 22.0.4; however, version 23.3.1 is available.
   You should consider upgrading via the python -m pip install --upgrade pip' command.
   ```
   
   You can ignore the warning message at the end about upgrading `pip`.
   
### Running the scripts

Now that you have ensured that the prerequisites are met, you can run either script. Here is a sample run of each.

#### `diffie_hellman.py`

   ```bash
   $ python .\diffie_hellman.py
   
   What value for p? 123941217
   What value for g? 12431
   
   Beginning quality evaluation of p and g.
   
     | This message is a reminder that when Diffie Hellman or similar algorithms are used, the primes involved are very large.
     | I'll give an example of what "very large" means in another script.
   
     | Your choice for p (123941217) is not prime. This will be discussed with your parole officer.
     | Your choice for g (12431) is not prime. This will be discussed with your parole officer.
     | Neither p nor g are prime, but at least they are co-prime. You think this makes you smarter than a fifth grader, don't you?
      
      Alice has learned that g has the value 12431.
      Bob has learned that g has the value 12431.
      Eve has learned that g has the value 12431.
      
      Alice has learned that p has the value 123941217.
      Bob has learned that p has the value 123941217.
      Eve has learned that p has the value 123941217.
      
      Alice has learned that public_key_a has the value 32385280.
      Bob has learned that public_key_a has the value 32385280.
      Eve has learned that public_key_a has the value 32385280.
      
      Alice has learned that public_key_b has the value 60503561.
      Bob has learned that public_key_b has the value 60503561.
      Eve has learned that public_key_b has the value 60503561.
      
      Hi, my name is Alice. Thanks for having me. Here's everything I know.
        The value of g is 12431
        The value of p is 123941217
        The value of private_key_a is 76896
        The value of public_key_a is 32385280
        The value of public_key_b is 60503561
        The value of secret is 65866612
      
      Hi, my name is Bob. Thanks for having me. Here's everything I know.
        The value of g is 12431
        The value of p is 123941217
        The value of private_key_b is 42435
        The value of public_key_a is 32385280
        The value of public_key_b is 60503561
        The value of secret is 65866612
      
      Hi, my name is Eve. Thanks for having me. Here's everything I know.
        The value of g is 12431
        The value of her darkest dream is that they won't get away with this
        The value of p is 123941217
        The value of public_key_a is 32385280
        The value of public_key_b is 60503561

      Bottom line:
        |   Bob calculated a secret of 65866612, and
        | Alice calculated a secret of 65866612.
   ```
#### `diffie_hellman_gmpy.py`

   ```bash
   > python .\diffie_hellman_gmpy.py

The values for the (g)enerator is 2. The value for the (p)rime is ... big. Here it is:
32317006071311007300338913926423828248817941241140239112842009751400741706634354222619689417363569347117901737909704191754605873209195028853758986185622153212175412514901774520270235796078236248884246189477587641105928646099411723245426622522193230540919037680524235519125679715870117001058055877651038861847280257976054903569732561526167081339361799541336476559160368317896729073178384589680639671900977202194168647225871031411336429319536193471636533209717077448227988588565369208645296636077250268955505928362751121174096972998068410554359584866583291642136218231078990999448652468262416972035911852507045361090559

The size of the the prime is 2048.000000 bits.

Publicly announcing the value of g.
Telling Alice the value of g.
Alice has learned the value of g.
Telling Bob the value of g.
Bob has learned the value of g.
Telling Eve the value of g.
Eve has learned the value of g.


Publicly announcing the value of p.
Telling Alice the value of p.
Alice has learned the value of p.
Telling Bob the value of p.
Bob has learned the value of p.
Telling Eve the value of p.
Eve has learned the value of p.

Alice has learned the value of private_key_a.

Alice has chosen private key 32317006071311007300714876688669951960444102669715484032130345427524655138867890893197201411522913461841849619151304887471793242650400463207078526045456573310994467998021096205202832471039506568122794740058766551276676221841775680370153332619008684961018518849794013687681974641830657071178510547997303757341774495611983275661056197175397595700017821925312730723300151071139279627240291571871769478503912316634590059191468784131795169045987986264292433480776789836205119831657226507415120047369950098272768785115621949087371385288543905757165685161186612037351669165105458569746911937388298371420322579249718085287936.
The size of this private key is 2048.000000 bits.

Alice has generated public key 30986968185632384781573526765768408097098588826245970726274077206076263126635585229535641816955409364982108219710096917883346309731432294505862042509788212165477678757036998174057899613612428937373080282811558883786149466936551796033265794026583484420158552930941463200365100887887374070802226867651476466393365541876187412471222792852849020238037984560222649757652126431126467008864114930568766903252167194800911854275103605044700966793939003717998586423654776500800927457928261275015252627128265988513921064972657251545828985130276763732525359935779470357574185952678565268865214601437294395339065010358313941899569.
The size of this public key is 2047.939368 bits.

Publicly announcing the value of public_key_a.
Telling Alice the value of public_key_a.
Alice has learned the value of public_key_a.
Telling Bob the value of public_key_a.
Bob has learned the value of public_key_a.
Telling Eve the value of public_key_a.
Eve has learned the value of public_key_a.

Bob has learned the value of private_key_b.

Bob has chosen private key 32317006071311007300714876688669951960444102669715484032130345427524655138863425371411155773500388300906028919755407093275859601670584370702513147944031558322156069849439928238745272289762991841877634598931635741525217592894049920968373867297913316632782950820461628346533456783572810976446122577951799260429412422096775593194419388107339999267637669229831773091906485300266306797459741878099561903571072914453308773840630719780918507095674328107680912654174296684581393349044039272018320273109575943286575317347986542612047526574184089857000281723764840126939273890980048962779782920501125435050405857519965854236672.
The size of this private key is 2048.000000 bits.

Bob has generated public key 5870790804407408290790765107181474594475333837692579263827415622289239268648860069330183439478283957116333876588234723631188223222529416813653920064217769718388871683972628180558762709689685301883314204899167264544862057965452654245597335191394182900429616758417733616739828909515361565233285836269078975868506553309671845486965248275315264669728597374687400970028860355529996429948967297371538878085454361962037551786345350530988617105489604500077355022406093783572440881127346160033488455461168627604217577240775452021625396963217100788012959612523941443260042969287792010867877836942500321931944783931909094776648.
The size of this public key is 2045.539333 bits.

Publicly announcing the value of public_key_b.
Telling Alice the value of public_key_b.
Alice has learned the value of public_key_b.
Telling Bob the value of public_key_b.
Bob has learned the value of public_key_b.
Telling Eve the value of public_key_b.
Eve has learned the value of public_key_b.

Alice has learned the value of secret.
Bob has learned the value of secret.
Eve has learned the value of her own self-esteem.

Hi, my name is Alice. Thanks for having me. Here's everything I know.
  The value of g is 2.
  The value of p is 32317006071311007300338913926423828248817941241140239112842009751400741706634354222619689417363569347117901737909704191754605873209195028853758986185622153212175412514901774520270235796078236248884246189477587641105928646099411723245426622522193230540919037680524235519125679715870117001058055877651038861847280257976054903569732561526167081339361799541336476559160368317896729073178384589680639671900977202194168647225871031411336429319536193471636533209717077448227988588565369208645296636077250268955505928362751121174096972998068410554359584866583291642136218231078990999448652468262416972035911852507045361090559.
  The value of private_key_a is 32317006071311007300714876688669951960444102669715484032130345427524655138867890893197201411522913461841849619151304887471793242650400463207078526045456573310994467998021096205202832471039506568122794740058766551276676221841775680370153332619008684961018518849794013687681974641830657071178510547997303757341774495611983275661056197175397595700017821925312730723300151071139279627240291571871769478503912316634590059191468784131795169045987986264292433480776789836205119831657226507415120047369950098272768785115621949087371385288543905757165685161186612037351669165105458569746911937388298371420322579249718085287936.
  The value of public_key_a is 30986968185632384781573526765768408097098588826245970726274077206076263126635585229535641816955409364982108219710096917883346309731432294505862042509788212165477678757036998174057899613612428937373080282811558883786149466936551796033265794026583484420158552930941463200365100887887374070802226867651476466393365541876187412471222792852849020238037984560222649757652126431126467008864114930568766903252167194800911854275103605044700966793939003717998586423654776500800927457928261275015252627128265988513921064972657251545828985130276763732525359935779470357574185952678565268865214601437294395339065010358313941899569.
  The value of public_key_b is 5870790804407408290790765107181474594475333837692579263827415622289239268648860069330183439478283957116333876588234723631188223222529416813653920064217769718388871683972628180558762709689685301883314204899167264544862057965452654245597335191394182900429616758417733616739828909515361565233285836269078975868506553309671845486965248275315264669728597374687400970028860355529996429948967297371538878085454361962037551786345350530988617105489604500077355022406093783572440881127346160033488455461168627604217577240775452021625396963217100788012959612523941443260042969287792010867877836942500321931944783931909094776648.
  The value of secret is 29022430656532379769542836684471127168084018184330086964520181069736947443871029632077752526070806779225969232798632816012896190867632045485359337492593216595411846275989162786776871067742948070311407029046377242568534247516545509348457460921883258530031486660147200255586460263329231979089270708861128630736647405578935665108102841938784014108911187316087454196192203107825979661060073801162597587113659178488766501333640984857543387884432410538104806567568792609449049449864327344584453777150171154481643202783254967703792287699846437229128410142258195869984129616635125337083296460659170308824601160193902314209256.

Hi, my name is Bob. Thanks for having me. Here's everything I know.
  The value of g is 2.
  The value of p is 32317006071311007300338913926423828248817941241140239112842009751400741706634354222619689417363569347117901737909704191754605873209195028853758986185622153212175412514901774520270235796078236248884246189477587641105928646099411723245426622522193230540919037680524235519125679715870117001058055877651038861847280257976054903569732561526167081339361799541336476559160368317896729073178384589680639671900977202194168647225871031411336429319536193471636533209717077448227988588565369208645296636077250268955505928362751121174096972998068410554359584866583291642136218231078990999448652468262416972035911852507045361090559.
  The value of private_key_b is 32317006071311007300714876688669951960444102669715484032130345427524655138863425371411155773500388300906028919755407093275859601670584370702513147944031558322156069849439928238745272289762991841877634598931635741525217592894049920968373867297913316632782950820461628346533456783572810976446122577951799260429412422096775593194419388107339999267637669229831773091906485300266306797459741878099561903571072914453308773840630719780918507095674328107680912654174296684581393349044039272018320273109575943286575317347986542612047526574184089857000281723764840126939273890980048962779782920501125435050405857519965854236672.
  The value of public_key_a is 30986968185632384781573526765768408097098588826245970726274077206076263126635585229535641816955409364982108219710096917883346309731432294505862042509788212165477678757036998174057899613612428937373080282811558883786149466936551796033265794026583484420158552930941463200365100887887374070802226867651476466393365541876187412471222792852849020238037984560222649757652126431126467008864114930568766903252167194800911854275103605044700966793939003717998586423654776500800927457928261275015252627128265988513921064972657251545828985130276763732525359935779470357574185952678565268865214601437294395339065010358313941899569.
  The value of public_key_b is 5870790804407408290790765107181474594475333837692579263827415622289239268648860069330183439478283957116333876588234723631188223222529416813653920064217769718388871683972628180558762709689685301883314204899167264544862057965452654245597335191394182900429616758417733616739828909515361565233285836269078975868506553309671845486965248275315264669728597374687400970028860355529996429948967297371538878085454361962037551786345350530988617105489604500077355022406093783572440881127346160033488455461168627604217577240775452021625396963217100788012959612523941443260042969287792010867877836942500321931944783931909094776648.
  The value of secret is 29022430656532379769542836684471127168084018184330086964520181069736947443871029632077752526070806779225969232798632816012896190867632045485359337492593216595411846275989162786776871067742948070311407029046377242568534247516545509348457460921883258530031486660147200255586460263329231979089270708861128630736647405578935665108102841938784014108911187316087454196192203107825979661060073801162597587113659178488766501333640984857543387884432410538104806567568792609449049449864327344584453777150171154481643202783254967703792287699846437229128410142258195869984129616635125337083296460659170308824601160193902314209256.

Hi, my name is Eve. Thanks for having me. Here's everything I know.
  The value of g is 2.
  The value of her own self-esteem is fully and permanently destroyed.
  The value of p is 32317006071311007300338913926423828248817941241140239112842009751400741706634354222619689417363569347117901737909704191754605873209195028853758986185622153212175412514901774520270235796078236248884246189477587641105928646099411723245426622522193230540919037680524235519125679715870117001058055877651038861847280257976054903569732561526167081339361799541336476559160368317896729073178384589680639671900977202194168647225871031411336429319536193471636533209717077448227988588565369208645296636077250268955505928362751121174096972998068410554359584866583291642136218231078990999448652468262416972035911852507045361090559.
  The value of public_key_a is 30986968185632384781573526765768408097098588826245970726274077206076263126635585229535641816955409364982108219710096917883346309731432294505862042509788212165477678757036998174057899613612428937373080282811558883786149466936551796033265794026583484420158552930941463200365100887887374070802226867651476466393365541876187412471222792852849020238037984560222649757652126431126467008864114930568766903252167194800911854275103605044700966793939003717998586423654776500800927457928261275015252627128265988513921064972657251545828985130276763732525359935779470357574185952678565268865214601437294395339065010358313941899569.
  The value of public_key_b is 5870790804407408290790765107181474594475333837692579263827415622289239268648860069330183439478283957116333876588234723631188223222529416813653920064217769718388871683972628180558762709689685301883314204899167264544862057965452654245597335191394182900429616758417733616739828909515361565233285836269078975868506553309671845486965248275315264669728597374687400970028860355529996429948967297371538878085454361962037551786345350530988617105489604500077355022406093783572440881127346160033488455461168627604217577240775452021625396963217100788012959612523941443260042969287792010867877836942500321931944783931909094776648.

BOTTOM LINE:
------------
Did Alice and Bob generate the same key?

Alice's secret: 29022430656532379769542836684471127168084018184330086964520181069736947443871029632077752526070806779225969232798632816012896190867632045485359337492593216595411846275989162786776871067742948070311407029046377242568534247516545509348457460921883258530031486660147200255586460263329231979089270708861128630736647405578935665108102841938784014108911187316087454196192203107825979661060073801162597587113659178488766501333640984857543387884432410538104806567568792609449049449864327344584453777150171154481643202783254967703792287699846437229128410142258195869984129616635125337083296460659170308824601160193902314209256.
Bob's secret:   29022430656532379769542836684471127168084018184330086964520181069736947443871029632077752526070806779225969232798632816012896190867632045485359337492593216595411846275989162786776871067742948070311407029046377242568534247516545509348457460921883258530031486660147200255586460263329231979089270708861128630736647405578935665108102841938784014108911187316087454196192203107825979661060073801162597587113659178488766501333640984857543387884432410538104806567568792609449049449864327344584453777150171154481643202783254967703792287699846437229128410142258195869984129616635125337083296460659170308824601160193902314209256.
Alice's secret minus Bob's secret: 0.

Yep, they did.
   ```