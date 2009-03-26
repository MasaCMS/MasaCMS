<!---
Programmer: Tim McCarthy (tim@timmcc.com)
Date: February, 2003
Description:
	Produces a 256-bit condensed representation of a message (attributes.msg) called
	a message digest (caller.msg_digest) using the Secure Hash Algorithm (SHA-256) as
	specified in FIPS PUB 180-2 (http://csrc.nist.gov/publications/fips/fips180-2/fips180-2.pdf)
	On August 26, 2002, NIST announced the approval of FIPS 180-2, Secure Hash Standard,
	which contains the specifications for the Secure Hash Algorithms (SHA-1, SHA-256, SHA-384,
	and SHA-256) with several examples.  This standard became effective on February 1, 2003.
Required parameter: msg
Optional parameter: format="hex" (hexadecimal, default is ASCII text)
Example syntax: <cf_sha_256 msg="abcdefghijklmnopqrstuvwxyz">
Output variable: caller.msg_digest
Note:
	This version accepts input in both ASCII text and hexadecimal formats.
	Previous versions did not accept input in hexadecimal format.
--->

<HTML>
<HEAD>
	<TITLE>Secure Hash Algorithm (SHA-256)</TITLE>
</HEAD>

<BODY>

<!--- default value of optional parameter --->
<CFPARAM name="attributes.format" default="">

<!--- convert the msg to ASCII binary-coded form --->
<CFIF attributes.format EQ "hex">
	<CFSET hex_msg = attributes.msg>
<CFELSE>
	<CFSET hex_msg = "">
	<CFLOOP index="i" from="1" to="#Len(attributes.msg)#">
		<CFSET hex_msg = hex_msg & Right("0"&FormatBaseN(Asc(Mid(attributes.msg,i,1)),16),2)>
	</CFLOOP>
</CFIF>

<!--- compute the msg length in bits --->
<CFSET hex_msg_len = FormatBaseN(4*Len(hex_msg),16)>

<!--- pad the msg to make it a multiple of 512 bits long --->
<CFSET padded_hex_msg = hex_msg & "80" & RepeatString("0",128-((Len(hex_msg)+2+16) Mod 128)) & RepeatString("0",16-Len(hex_msg_len)) & hex_msg_len>

<!--- first sixty-four prime numbers --->
<CFSET prime = ArrayNew(1)>
<CFSET prime[1] = 2>
<CFSET prime[2] = 3>
<CFSET prime[3] = 5>
<CFSET prime[4] = 7>
<CFSET prime[5] = 11>
<CFSET prime[6] = 13>
<CFSET prime[7] = 17>
<CFSET prime[8] = 19>
<CFSET prime[9] = 23>
<CFSET prime[10] = 29>
<CFSET prime[11] = 31>
<CFSET prime[12] = 37>
<CFSET prime[13] = 41>
<CFSET prime[14] = 43>
<CFSET prime[15] = 47>
<CFSET prime[16] = 53>
<CFSET prime[17] = 59>
<CFSET prime[18] = 61>
<CFSET prime[19] = 67>
<CFSET prime[20] = 71>
<CFSET prime[21] = 73>
<CFSET prime[22] = 79>
<CFSET prime[23] = 83>
<CFSET prime[24] = 89>
<CFSET prime[25] = 97>
<CFSET prime[26] = 101>
<CFSET prime[27] = 103>
<CFSET prime[28] = 107>
<CFSET prime[29] = 109>
<CFSET prime[30] = 113>
<CFSET prime[31] = 127>
<CFSET prime[32] = 131>
<CFSET prime[33] = 137>
<CFSET prime[34] = 139>
<CFSET prime[35] = 149>
<CFSET prime[36] = 151>
<CFSET prime[37] = 157>
<CFSET prime[38] = 163>
<CFSET prime[39] = 167>
<CFSET prime[40] = 173>
<CFSET prime[41] = 179>
<CFSET prime[42] = 181>
<CFSET prime[43] = 191>
<CFSET prime[44] = 193>
<CFSET prime[45] = 197>
<CFSET prime[46] = 199>
<CFSET prime[47] = 211>
<CFSET prime[48] = 223>
<CFSET prime[49] = 227>
<CFSET prime[50] = 229>
<CFSET prime[51] = 233>
<CFSET prime[52] = 239>
<CFSET prime[53] = 241>
<CFSET prime[54] = 251>
<CFSET prime[55] = 257>
<CFSET prime[56] = 263>
<CFSET prime[57] = 269>
<CFSET prime[58] = 271>
<CFSET prime[59] = 277>
<CFSET prime[60] = 281>
<CFSET prime[61] = 283>
<CFSET prime[62] = 293>
<CFSET prime[63] = 307>
<CFSET prime[64] = 311>

<!--- constants --->
<CFSET k = ArrayNew(1)>
<CFLOOP index="i" from="1" to="64">
	<CFSET k[i] = Int(prime[i]^(1/3)*2^32)>
</CFLOOP>

<!--- initial hash values --->
<CFSET h = ArrayNew(1)>
<CFLOOP index="i" from="1" to="8">
	<CFSET h[i] = Int(Sqr(prime[i])*2^32)>
	<CFLOOP condition="(h[i] LT -2^31) OR (h[i] GE 2^31)">
		<CFSET h[i] = h[i] - Sgn(h[i])*2^32>
	</CFLOOP>
</CFLOOP>

<CFSET w = ArrayNew(1)>

<!--- process the msg 512 bits at a time --->
<CFLOOP index="n" from="1" to="#Evaluate(Len(padded_hex_msg)/128)#">
	
	<!--- initialize the eight working variables --->
	<CFSET a = h[1]>
	<CFSET b = h[2]>
	<CFSET c = h[3]>
	<CFSET d = h[4]>
	<CFSET e = h[5]>
	<CFSET f = h[6]>
	<CFSET g = h[7]>
	<CFSET hh = h[8]>
	
	<!--- nonlinear functions and message schedule --->
	<CFSET msg_block = Mid(padded_hex_msg,128*(n-1)+1,128)>
	<CFLOOP index="t" from="0" to="63">
		
		<CFIF t LE 15>
			<CFSET w[t+1] = InputBaseN(Mid(msg_block,8*t+1,8),16)>
		<CFELSE>
			<CFSET smsig0 = BitXor(BitXor(BitOr(BitSHRN(w[t-15+1],7),BitSHLN(w[t-15+1],32-7)),BitOr(BitSHRN(w[t-15+1],18),BitSHLN(w[t-15+1],32-18))),BitSHRN(w[t-15+1],3))>
			<CFSET smsig1 = BitXor(BitXor(BitOr(BitSHRN(w[t-2+1],17),BitSHLN(w[t-2+1],32-17)),BitOr(BitSHRN(w[t-2+1],19),BitSHLN(w[t-2+1],32-19))),BitSHRN(w[t-2+1],10))>
			<CFSET w[t+1] = smsig1 + w[t-7+1] + smsig0 + w[t-16+1]>
		</CFIF>
		<CFLOOP condition="(w[t+1] LT -2^31) OR (w[t+1] GE 2^31)">
			<CFSET w[t+1] = w[t+1] - Sgn(w[t+1])*2^32>
		</CFLOOP>
		
		<CFSET bgsig0 = BitXor(BitXor(BitOr(BitSHRN(a,2),BitSHLN(a,32-2)),BitOr(BitSHRN(a,13),BitSHLN(a,32-13))),BitOr(BitSHRN(a,22),BitSHLN(a,32-22)))>
		<CFSET bgsig1 = BitXor(BitXor(BitOr(BitSHRN(e,6),BitSHLN(e,32-6)),BitOr(BitSHRN(e,11),BitSHLN(e,32-11))),BitOr(BitSHRN(e,25),BitSHLN(e,32-25)))>
		<CFSET ch = BitXor(BitAnd(e,f),BitAnd(BitNot(e),g))>
		<CFSET maj = BitXor(BitXor(BitAnd(a,b),BitAnd(a,c)),BitAnd(b,c))>
		
		<CFSET t1 = hh + bgsig1 + ch + k[t+1] + w[t+1]>
		<CFSET t2 = bgsig0 + maj>
		<CFSET hh = g>
		<CFSET g = f>
		<CFSET f = e>
		<CFSET e = d + t1>
		<CFSET d = c>
		<CFSET c = b>
		<CFSET b = a>
		<CFSET a = t1 + t2>
		
		<CFLOOP condition="(a LT -2^31) OR (a GE 2^31)">
			<CFSET a = a - Sgn(a)*2^32>
		</CFLOOP>
		<CFLOOP condition="(e LT -2^31) OR (e GE 2^31)">
			<CFSET e = e - Sgn(e)*2^32>
		</CFLOOP>
		
	</CFLOOP>
	
	<CFSET h[1] = h[1] + a>
	<CFSET h[2] = h[2] + b>
	<CFSET h[3] = h[3] + c>
	<CFSET h[4] = h[4] + d>
	<CFSET h[5] = h[5] + e>
	<CFSET h[6] = h[6] + f>
	<CFSET h[7] = h[7] + g>
	<CFSET h[8] = h[8] + hh>
	
	<CFLOOP index="i" from="1" to="8">
		<CFLOOP condition="(h[i] LT -2^31) OR (h[i] GE 2^31)">
			<CFSET h[i] = h[i] - Sgn(h[i])*2^32>
		</CFLOOP>
	</CFLOOP>
	
</CFLOOP>

<CFLOOP index="i" from="1" to="8">
	<CFSET h[i] = RepeatString("0",8-Len(FormatBaseN(h[i],16))) & UCase(FormatBaseN(h[i],16))>
</CFLOOP>

<CFSET caller.msg_digest = h[1] & h[2] & h[3] & h[4] & h[5] & h[6] & h[7] & h[8]>

</BODY>

</HTML>