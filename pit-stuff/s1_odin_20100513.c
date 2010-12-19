/*
   Copyright 2010 Hexabit (http://forum.xda-developers.com/member.php?u=3074759)
   Copyright 2010 Kolja Dummann (k.dummann@gmail.com)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

*/

struct PIT {
	unsigned int	magic;			/* file magic */
	unsigned int	nument;			/* number of entries in file */
	unsigned int	_08;			/* unknown */
	unsigned int	_0C;			/* unknown */
	unsigned int	_10;			/* unknown */
	unsigned int	_14;			/* unknown */
	unsigned int	_18;			/* unknown */

	struct Entry {
		unsigned int	_00;		/* unknown. set to 1 is entry unused */
		unsigned int	_04;		/* unknown. set to 1 is entry unused */
		unsigned int	partid;		/* partition ID */	
		unsigned int	flags;		/* flags. 0x 00= RO, 0x02=R/W */
		unsigned int	_14;		/* unknown */
		unsigned int	blocksize;	/* blocksize in 512 byte units */
		unsigned int	partsize;	/* partition size in blocks */
		char		_20[8];		/* unknown */
		char		partname[32];	/* partition name */
		char		filename[64];	/* filename */
	} Entries[13];

} s1_odin_20100513 = {

	0x12349876,
	13,
	1,
	0,
	0x00411d54,
	0x0012fae0,
	0x0043d808,

{

	{ 0, 0, 0x00, 0x00, 0, 256,    1, 
	"o\0f\0t\0 ",
	"IBL+PBL\0"  /*concat*/ "S\0e\0r\0v\0e\0r\0\\\09\0\x30\0\\\0T\0o",
	"boot.bin\0" /*concat*/ "\0i\0n\0n\0;\0C\0:\0\\\0P\0r\0o\0g\0\0\0a\0m\0 \0F\0i\0l\0e\0s\0\\\0E\0S\0T\0s\0o\0f",
	},

	{ 0, 0, 0x01, 0x00, 0, 256,    1, "", "PIT",       "\0ries.pit"},
	{ 0, 0, 0x14, 0x02, 0, 256,   40, "", "EFS",       "efs.rfs"},
	{ 0, 0, 0x03, 0x00, 0, 256,    5, "", "SBL",       "sbl.bin"},
	{ 0, 0, 0x04, 0x00, 0, 256,    5, "", "SBL2",      "sbl.bin"},
	{ 0, 0, 0x15, 0x02, 0, 256,   20, "", "PARAM",     "param.lfs"},
	{ 0, 0, 0x06, 0x00, 0, 256,   30, "", "KERNEL",    "zImage"},
	{ 0, 0, 0x07, 0x00, 0, 256,   30, "", "RECOVERY",  "zImage"},
	{ 0, 0, 0x16, 0x02, 0, 256, 1226, "", "FACTORYFS", "factoryfs.rfs"},
	{ 0, 0, 0x17, 0x02, 0, 256,  456, "", "DBDATAFS",  "dbdata.rfs"},
	{ 0, 0, 0x18, 0x02, 0, 256,  140, "", "CACHE",     "cache.rfs"},
	{ 0, 0, 0x0b, 0x00, 0, 256,   50, "", "MODEM",     "modem.bin"},
	{ 1, 1, 0x0b, 0x00, 0,   0,    0, "", "", ""},

}};
