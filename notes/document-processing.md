## PDF

To extract a page range from a PDF (requires [`pdftk`](https://www.pdflabs.com/docs/pdftk-cli-examples/)):
```
pdftk full-pdf.pdf cat 12-15 output outfile_p12-15.pdf
```
You can add a `compress` at the end of the above command to generate a compressed PDF.

To make it look as if a PDF was scanned, go to [lookscanned.io](https://lookscanned.io/scan).

To « handwrite » on a PDF, use Xournal:
```
nix run 'np#xournalpp'
```

## CSV

To manipulate CSVs on the command-line (requires [`csvkit`](https://csvkit.readthedocs.io/en/latest/)):
```
csvstat file.csv
csvcut -c column1,column5 file.csv
csvstack file1.csv file2.csv > merged.csv
```
