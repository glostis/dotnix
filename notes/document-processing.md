To extract a page range from a PDF (requires [`pdftk`](https://www.pdflabs.com/docs/pdftk-cli-examples/)):
```
pdftk full-pdf.pdf cat 12-15 output outfile_p12-15.pdf
```

To manipulate CSVs on the command-line (requires [`csvkit`](https://csvkit.readthedocs.io/en/latest/)):
```
csvstat file.csv
csvcut -c column1,column5 file.csv
csvstack file1.csv file2.csv > merged.csv
```
