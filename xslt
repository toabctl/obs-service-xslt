#!/usr/bin/python3
#
# Copyright 2019 SUSE Linux GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

import argparse
import os
import subprocess
import sys


XSLTPROC_BIN = "/usr/bin/xsltproc"


def parse_args():
    parser = argparse.ArgumentParser(description='renderspec source service')
    parser.add_argument('--outdir', default='.',
                        help='osc service parameter that does nothing')
    parser.add_argument('--input-file', action='append',
                        help='a input file name')
    parser.add_argument('--output-file',
                        help='name of the output file')
    return parser.parse_args()


if __name__ == '__main__':
    args = parse_args()
    if not args.input_file:
        print('No input file(s) given')
        sys.exit(1)

    if not args.output_file:
        print('No output file given')
        sys.exit(1)

    if not os.path.exists(XSLTPROC_BIN):
        print('{} not available'.format(XSLTPROC_BIN))
        sys.exit(1)

    cmd = [XSLTPROC_BIN, '--output', args.output_file]
    # process input files
    for f in args.input_file:
        if not os.path.exists(f):
            print('input file "{}" does not exist'.format(f))
            sys.exit(1)
        cmd.append(f)
    try:
        subprocess.check_output(cmd)
    except subprocess.CalledProcessError as e:
        print('Failed to call "{}" (return code: {})'.format(
            e.cmd, e.returncode))
        # stdout/stderr were added in python3.5
        if hasattr(e, 'stdout'):
            print(e.stdout)
        if hasattr(e, 'stderr'):
            print(e.stderr)
        sys.exit(1)
    sys.exit(0)
