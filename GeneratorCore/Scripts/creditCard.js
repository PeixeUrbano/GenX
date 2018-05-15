// Copyright (c) 2015, Brad Conte (http://bradconte.com)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the <organization> nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function generate(issuer, len) {
    if (typeof(len) == "undefined") len = 16;

	var pos;
	var str = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	var sum = 0;
	var final_digit = 0;
	var t = 0;
	var len_offset = 0;
	var issuer;

	//
	// Fill in the first values of the string based with the specified bank's prefix.
	//

	// Visa
	if (issuer == "visa") {
		str[0] = 4;
		pos = 1;
	}
	// Mastercard
	else if (issuer == "mastercard") {
		str[0] = 5;
		t = Math.floor(Math.random() * 5) % 5;
		str[1] = 1 + t;	  // Between 1 and 5.
		pos = 2;
		len = 16;
	}
	// American Express
	else if (issuer == "amex") {
		str[0] = 3;
		t = Math.floor(Math.random() * 4) % 4;
		str[1] = 4 + t;	  // Between 4 and 7.
		pos = 2;
		len = 15;
	}
	// Discover
	else if (issuer == "discover") {
		str[0] = 6;
		str[1] = 0;
		str[2] = 1;
		str[3] = 1;
		pos = 4;
		len = 16;
	}

	//
	// Fill all the remaining numbers except for the last one with random values.
	//

	while (pos < len - 1) {
		str[pos++] = Math.floor(Math.random() * 10) % 10;
	}

	//
	// Calculate the Luhn checksum of the values thus far.
	//

	len_offset = (len + 1) % 2;
	for (pos = 0; pos < len - 1; pos++) {
		if ((pos + len_offset) % 2) {
			t = str[pos] * 2;
			if (t > 9) {
				t -= 9;
			}
			sum += t;
		}
		else {
			sum += str[pos];
		}
	}

	//
	// Choose the last digit so that it causes the entire string to pass the checksum.
	//

	final_digit = (10 - (sum % 10)) % 10;
	str[len - 1] = final_digit;

	// Output the CC value.
	t = str.join('');
	t = t.substr(0, len);
	return t;
}