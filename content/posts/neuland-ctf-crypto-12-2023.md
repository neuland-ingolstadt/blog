---
title: "Neuland CTF 2023 Winter - Cryptography"
authors: ["Neuland CTF Orga"]
date: 2023-12-09T21:00:00+02:00
draft: false
tags:
- ctf
- writeup
- security
- cyber
- cybersecurity
---

</br>

Download challenges: [Neuland CTF Repository](https://github.com/neuland-ingolstadt/Neuland-CTF-2023-Winter)

</br>

#### Secrets - Easy
*Part 1: ```aynaq{o4f3``` </br>
Part 2: ```..--.- -.... ....- ..--.- .---- ..... ..--.- -. --- --... ..--.- ....- ..--.-``` </br>
Part 3: ```M05DcllwNzFvbn0=``` </br>*

</br>

We get three parts of the flag encrypted/encoded by different methods. The first part of the message appears to represent ***nland{***. The fact that ***{*** remains the same and the two ***N***s have been converted to ***A***s indicates a shift cipher. The string is ROT 13 encoded; it simply substitutes a letter with the 13th letter after in the alphabet.
The second part consists exclusively of dots and dashes, indicating Morse code, which encodes text with two different signal durations. 
The last part is Base64, a binary-to-text encoding indicated by the ***=*** at the end of the sequence used as padding.

</br>

The flag is `nland{b4s3_64_15_NO7_4_3NCrYp71on}`.

</br>

#### Hash - Easy
*MD5: e10adc3949ba59abbe56e057f20f883e </br>
SHA1: 5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8 </br>
LM: 598DDCE2660D3193AAD3B435B51404EE </br>
</br>
Flag format: nland{<MD5\>\_<SHA1\>\_<LM\>} in all lowercase*

</br>

Die Flagge kann durch das bruteforcen von 3 verschiedenen Hash algorithmen erzeugt werden. Ein Hash ist ein digitaler Fingerabdruck welcher durch eine hashfunktion daten von beliebiger länger auf einen kürzeren, fixed-lengt value abbildet. In der It-SIcherheit sind diese Hashs meistens einwegfunktionen und bieten Kollisionsresistenz, damit ist es einfach einen Hash zu berechnen jedoch so gut wie unmöglich rückschlüsse auf den orginal String zu ziehen. Deshalb ist ein effiznter Weg die Hashes zu entschlüsseln eine Wörterbuchattacke, dabei wereden häufig genutzte Wörter mit der jeweiligen Hashalgorithmus gehased und mit dem orginal verglichen. Tools wie hashcat erleichtern uns dieses vorgehen. Wir laden uns ein Wörterbuch wie rockyou.txt herunter und nutzen es als eingabe für hashcat. Ein Durchlauf sieht wie folgt aus, die hast.txt datei enthält den Hashwert. 

```
hashcat.exe -a 0 -m 0 hash.txt rockyou.txt
hashcat.exe -a 0 -m 100 hash.txt rockyou.txt
hashcat.exe -a 0 -m 3000 hash.txt rockyou.txt
```

Durch den parrameter a bestimmen wir den Modus Wörterbuch, das m steht für den Hashagorithmus. Mit der rockyou.txt konnten alle Hashes entschlüsselt werden.

</br>

The flag is `nland{123456_password_qwerty}`.

</br>

#### Baby - Easy
*Can you read my message without the private key?*

```
c: 24795976732186127960014008753803478286219924961358994925564930277505139413283367757656447224830225064133651246343035441112407129772003927463166449052456907513
e: 65537
n: 67037366790941822378007197878613492487588187468048328737227273255156041659689092651657208107757810805499108569166854436320366276808520739379431210884782583791
```

</br>

The title already reveals that it is about the cryptographic method RSA. Since n only has 158 digits, we have a good chance of finding the two factors, q and p, needed to calculate the private key. [FactorDB](http://factorb.com/index.php) is an online collection of prime numbers which fortunately stores our fully factored n. The private key d can be calculated with `inverse(e) % (p-1) * (q-1)`. With the private key, the ciphertext c can be decrypted with the equation `M = pow(C , d) % n`.

***Python script:***
```
from Crypto.Util.number import *

p = 7796601204626807
q = 8598280844627430267706791405975187760390046230909096659417881790296619284204527797467017995321195814866230752519838250409205362581256112387913
n = 67037366790941822378007197878613492487588187468048328737227273255156041659689092651657208107757810805499108569166854436320366276808520739379431210884782583791
c = 24795976732186127960014008753803478286219924961358994925564930277505139413283367757656447224830225064133651246343035441112407129772003927463166449052456907513
e = 65537

d = inverse(e,(p-1)*(q-1))
m = pow(c,d,p*q)
print("Message: ", long_to_bytes(m))
```

The flag is `nland{ROll1n9_your_Own_r54}`

</br>

#### All the Colors of Christmas - Medium
*Santa has a message for you.
(Flag format nland{<message>} in all lowercase)*

![](/images/neuland-ctf-12-2023/xmas.jpeg)

</br>

An LED-illuminated Christmas tree is provided to solve the task, which regularly changes its colors. After looking at it for a while, the following features become apparent:
- 6 different colors (green, yellow, blue, light blue, pink, red)
- The 6th color is displayed longer
- After 18 colors, the Christmas tree shuts down and starts again from the beginning

With this information, we can create the following pattern:

|   |   |    |   |   |   |   |   | 
|---|---|---|---|---|---|---|---|
| green | yellow | yellow | blue | green |  yellow | yellow | blue |
| red | blue | light blue | pink | red | blue | light blue | pink |
| light blue | pink | green | red | light blue | pink | green | red |

A quick Google search shows that only a few cryptographic algorithms use colors as a form of representation. One of them is Hexahue, which uses the same colors.

Enter the color combination into an [online decoder](https://www.dcode.fr/hexahue-cipher) and get the word ho.

![](/images/neuland-ctf-12-2023/hexahue.png)

</br>

The flag is `nland{hoho}`.