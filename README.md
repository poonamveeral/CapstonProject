# GeneralRepo Readme

## Goal

To provide: 

1. A minimal repository,
2. An installation manual with: software requirements, compile a markdown file, and update pandoc dependencies, 
3. A minimal example to test, edit, and generate a markdown file,

so that anyone willing to compile the lecture notes at <https://rocketgit.com/user/caubert/CSCI_3410> will be able to use this repository as a reference, test their installation, and then compile lectures notes if needed. 

## Getting Started 

The source code, hosted at <https://github.com/poonamveeral/GeneralRepo>, is organized as follows:

~~~{.plain}
.
├── install/                -- How to install requirements to compile the document.
├── bib/		    -- References (including reference to the document). 
├── code/		    -- Source code included in the document.
├── fig/		    -- Source code for various figures used in the document.
├── img/	            -- Various image files itegrated in the document.
├── latex/		    -- Latex configuration file.
├── style/                  -- CSS style used for the web page.
├── Makefile                -- Directives to generate example.md document.
├── README.md               -- The present file.
└── example.md              -- Sample file to test.
~~~ 

Before compiling this document, you will need to review the manual.md document in the 'Course' folder.
