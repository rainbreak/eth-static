<a href='https://travis-ci.org/rainbeam/eth-static'> <img src='https://travis-ci.org/rainbeam/eth-static.svg?branch=master'> </a>

## Static, portable builds of Eth

**Work in progess! Force pushing everywhere!**

This is a script to produce a fully static build of `eth`, the
Ethereum c++ client.

This is done by statically linking to musl in an Alpine Linux
environment. Unlike glibc, musl is built with static linking in
mind.
