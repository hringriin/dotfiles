#!/bin/bash
# set-defaults - set default xdg-mime settings for a couple of programmes

# Images
xdg-mime default sxiv.desktop \
    image/jpg \
    image/jpeg \
    image/pjpeg \
    image/png \
    image/gif \

# TIFF and Multi-TIFF
xdg-mime default mupdf.desktop \
    image/tiff \
    image/ttiff

# PDF
xdg-mime default mupdf.desktop \
    application/pdf \
    application/x-octet-stream \
    application/force-download

# HTML
xdg-mime default qutebrowser.desktop \
    text/html

# pgp keys
xdg-mime default vim.desktop \
    application/pgp-keys

# markdown, rmarkdown, LaTeX
xdg-mime default vim.desktop \
    text/x-markdown \
    text/x-tex

# office writer
xdg-mime default libreoffice-writer.desktop \
    application/msword \
    application/vnd.oasis.opendocument.text \
    application/vnd.openxmlformats-officedocument.wordprocessingml.document \
    application/odt \
    application/ott

# office calc
xdg-mime default libreoffice-calc.desktop \
    application/ods \
    application/ots \
    text/csv

# directories
xdg-mime default ranger.desktop \
    inode/directory
