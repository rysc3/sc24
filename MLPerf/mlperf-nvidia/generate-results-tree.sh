#!/bin/bash

cm run script --tags=generate,inference,submission \
   --clean \
   --preprocess_submission=yes \
   --run-checker \
   --tar=yes \
   --env.CM_TAR_OUTFILE=submission.tar.gz \
   --division=open \
   --category=datacenter \
   --env.CM_DETERMINE_MEMORY_CONFIGURATION=yes \
   --run_style=test \
   --adr.submission-checker.tags=_short-run \
   --quiet \
   --submitter="UNM-Roadrunners"
