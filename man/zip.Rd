% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zip.R
\name{zip}
\alias{zip}
\alias{zipr}
\alias{zip_append}
\alias{zipr_append}
\title{Compress Files into 'zip' Archives}
\usage{
zip(
  zipfile,
  files,
  recurse = TRUE,
  compression_level = 9,
  include_directories = TRUE,
  keys = files
)

zipr(
  zipfile,
  files,
  recurse = TRUE,
  compression_level = 9,
  include_directories = TRUE,
  keys = basename(normalizePath(files))
)

zip_append(
  zipfile,
  files,
  recurse = TRUE,
  compression_level = 9,
  include_directories = TRUE,
  keys = files
)

zipr_append(
  zipfile,
  files,
  recurse = TRUE,
  compression_level = 9,
  include_directories = TRUE,
  keys = basename(normalizePath(files))
)
}
\arguments{
\item{zipfile}{The zip file to create. If the file exists, \code{zip}
overwrites it, but \code{zip_append} appends to it.}

\item{files}{List of file to add to the archive. See details below
about absolute and relative path names.}

\item{recurse}{Whether to add the contents of directories recursively.}

\item{compression_level}{A number between 1 and 9. 9 compresses best,
but it also takes the longest.}

\item{include_directories}{Whether to explicitly include directories
in the archive. Including directories might confuse MS Office when
reading docx files, so set this to \code{FALSE} for creating them.}

\item{keys}{Custom file names to set in the zip archive.}
}
\value{
The name of the created zip file, invisibly.
}
\description{
\code{zipr} and \code{zip} both create a new zip archive file.
}
\details{
\code{zipr_append} and \code{zip_append} append compressed files to an
existing 'zip' file.
}
\section{Permissions}{


\code{zipr()} (and \code{zip()}, \code{zipr_append()}, etc.) add the permissions of
the archived files and directories to the ZIP archive, on Unix systems.
Most zip and unzip implementations support these, so they will be
recovered after extracting the archive.

Note, however that the owner and group (uid and gid) are currently
omitted, even on Unix.
}

\section{Relative paths}{


The difference between \code{zipr} and \code{zip} is how they handle the relative
paths of the input files.

For \code{zip} (and \code{zip_append}), the root of the archive is supposed to
be the current working directory. The paths of the files are fully kept
in the archive. Absolute paths are also kept. Note that this might result
non-portable archives: some zip tools do not handle zip archives that
contain absolute file names, or file names that start with \verb{..//} or
\verb{./}. This behavior is kept for compatibility, and we suggest that you
use \code{zipr} and \code{zipr_append} for new code.

E.g. for the following directory structure:\preformatted{foo
  bar
    file1
  bar2
    file2
foo2
  file3
}

Assuming the current working directory is \code{foo}, the following zip
entries are created by \code{zip}:\preformatted{zip("x.zip", c("bar/file1", "bar2", "../foo2"))
zip_list("x.zip")$filename
#> bar/file1
#> bar2
#> bar2/file2
#> ../foo2
#> ../foo2/file3
}

For \code{zipr} (and \code{zipr_append}), each specified file or directory in
\code{files} is created as a top-level entry in the zip archive.
We suggest that you use \code{zipr} and \code{zipr_append} for new code, as they
don't create non-portable archives. For the same directory structure,
these zip entries are created:\preformatted{zipr("x.zip", c("bar/file1", "bar2", "../foo2"))
zip_list("x.zip")$filename
#> file1
#> bar2
#> bar2/file2
#> foo2
#> foo2/file3
}

Because of the potential issues with \code{zip()} and \code{zip_append()},
they are now soft-deprecated, and their first use in the R session
will trigger a reminder message. To suppress this message, you can
use something like this:\preformatted{withCallingHandlers(
  zip::zip(...),
  deprecated = function(e) NULL)
}
}

\section{Custom file structure}{


Both \code{zipr} and \code{zip} allow manual specification of the file structure using
the argument \code{keys}.

Assuming files \code{bar/file1_2}, \code{dir1/file1_2}, \verb{dir1/file2_2"} and \code{foo2} to
exist in the current working directory, the names can be used to produce a
custom file structure as follows:\preformatted{zipr("x.zip", c("bar/file1_2", "dir1_2", "foo2"),
     keys = c("file1", "dir1", "foo2"))
zip_list("x.zip")$filename
#> file1
#> dir1
#> dir1/file1_2
#> dir1/file2_2
#> foo2
}
}

\examples{
## Some files to zip up
dir.create(tmp <- tempfile())
cat("first file", file = file.path(tmp, "file1"))
cat("second file", file = file.path(tmp, "file2"))

zipfile <- tempfile(fileext = ".zip")
zipr(zipfile, tmp)

## List contents
zip_list(zipfile)

## Add another file
cat("third file", file = file.path(tmp, "file3"))
zipr_append(zipfile, file.path(tmp, "file3"))
zip_list(zipfile)
}
