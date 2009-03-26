<!---
Programmer: Tim McCarthy (tim@timmcc.com)
Date: February, 2003
Description:
	Produces a 160-bit condensed representation of a message (attributes.msg) called
	a message digest (caller.msg_digest) using the Secure Hash Algorithm (SHA-1)
	as specified in FIPS PUB 180-1 (http://www.itl.nist.gov/fipspubs/fip180-1.htm)
Required parameter: msg
Optional parameter: format="hex" (hexadecimal, default is ASCII text)
Example syntax: <cf_sha_1 msg="abcdefghijklmnopqrstuvwxyz">
Output variable: caller.msg_digest
Note:
	This version accepts input in both ASCII text and hexadecimal formats.
	Previous versions did not accept input in hexadecimal format.
--->

<HTML>
<HEAD>
	<TITLE>Secure Hash Algorithm (SHA-1)</TITLE>
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

<!--- initialize the buffers --->
<CFSET h = ArrayNew(1)>
<CFSET h[1] = InputBaseN("0x67452301",16)>
<CFSET h[2] = InputBaseN("0xefcdab89",16)>
<CFSET h[3] = InputBaseN("0x98badcfe",16)>
<CFSET h[4] = InputBaseN("0x10325476",16)>
<CFSET h[5] = InputBaseN("0xc3d2e1f0",16)>

<CFSET w = ArrayNew(1)>

<!--- process the msg 512 bits at a time --->
<CFLOOP index="n" from="1" to="#Evaluate(Len(padded_hex_msg)/128)#">
	
	<CFSET msg_block = Mid(padded_hex_msg,128*(n-1)+1,128)>
	
	<CFSET a = h[1]>
	<CFSET b = h[2]>
	<CFSET c = h[3]>
	<CFSET d = h[4]>
	<CFSET e = h[5]>
	
	<CFLOOP index="t" from="0" to="79">
		
		<!--- nonlinear functions and constants --->
		<CFIF t LE 19>
			<CFSET f = BitOr(BitAnd(b,c),BitAnd(BitNot(b),d))>
			<CFSET k = InputBaseN("0x5a827999",16)>
		<CFELSEIF t LE 39>
			<CFSET f = BitXor(BitXor(b,c),d)>
			<CFSET k = InputBaseN("0x6ed9eba1",16)>
		<CFELSEIF t LE 59>
			<CFSET f = BitOr(BitOr(BitAnd(b,c),BitAnd(b,d)),BitAnd(c,d))>
			<CFSET k = InputBaseN("0x8f1bbcdc",16)>
		<CFELSE>
			<CFSET f = BitXor(BitXor(b,c),d)>
			<CFSET k = InputBaseN("0xca62c1d6",16)>
		</CFIF>
		
		<!--- transform the msg block from 16 32-bit words to 80 32-bit words --->
		<CFIF t LE 15>
			<CFSET w[t+1] = InputBaseN(Mid(msg_block,8*t+1,8),16)>
		<CFELSE>
			<CFSET num = BitXor(BitXor(BitXor(w[t-3+1],w[t-8+1]),w[t-14+1]),w[t-16+1])>
			<CFSET w[t+1] = BitOr(BitSHLN(num,1),BitSHRN(num,32-1))>
		</CFIF>
		
		<CFSET temp = BitOr(BitSHLN(a,5),BitSHRN(a,32-5)) + f + e + w[t+1] + k>
		<CFSET e = d>
		<CFSET d = c>
		<CFSET c = BitOr(BitSHLN(b,30),BitSHRN(b,32-30))>
		<CFSET b = a>
		<CFSET a = temp>
		
		<CFSET num = a>
		<CFLOOP condition="(num LT -2^31) OR (num GE 2^31)">
			<CFSET num = num - Sgn(num)*2^32>
		</CFLOOP>
		<CFSET a = num>
		
	</CFLOOP>
	
	<CFSET h[1] = h[1] + a>
	<CFSET h[2] = h[2] + b>
	<CFSET h[3] = h[3] + c>
	<CFSET h[4] = h[4] + d>
	<CFSET h[5] = h[5] + e>
	
	<CFLOOP index="i" from="1" to="5">
		<CFLOOP condition="(h[i] LT -2^31) OR (h[i] GE 2^31)">
			<CFSET h[i] = h[i] - Sgn(h[i])*2^32>
		</CFLOOP>
	</CFLOOP>
	
</CFLOOP>

<CFLOOP index="i" from="1" to="5">
	<CFSET h[i] = RepeatString("0",8-Len(FormatBaseN(h[i],16))) & UCase(FormatBaseN(h[i],16))>
</CFLOOP>

<CFSET caller.msg_digest = h[1] & h[2] & h[3] & h[4] & h[5]>

</BODY>

</HTML>