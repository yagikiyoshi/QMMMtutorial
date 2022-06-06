mol load pdb h2po4.pdb
package require psfgen
topology po4.rtf
segment PO4 {pdb h2po4.pdb}
coordpdb h2po4.pdb PO4
guesscoord
writepdb tmp.pdb
writepsf tmp.psf
package require solvate
solvate tmp.psf tmp.pdb -minmax {{-25.1 -25.1 -25.1} {25.1 25.1 25.1}} -o wbox 
package require autoionize
autoionize -psf wbox.psf -pdb wbox.pdb -neutralize
exit
