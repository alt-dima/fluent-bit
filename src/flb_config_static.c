/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */

/*  Fluent Bit
 *  ==========
 *  Copyright (C) 2019-2021 The Fluent Bit Authors
 *  Copyright (C) 2015-2018 Treasure Data Inc.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include <fluent-bit/flb_info.h>
#include <fluent-bit/flb_config_format.h>
#include <fluent-bit/conf/flb_static_conf.h>

/*
 * If Fluent Bit has static configuration support, this function allows to lookup,
 * parse and create configuration file contexts from the entries generated by
 * CMake at build-time.
 *
 * This routing passes a 'virtual' file name that should be registered into the
 * static array 'flb_config_files'. Learn more about it at:
 *
 *   include/fluent-bit/conf/flb_static_conf.h
 *
 */
struct flb_cf *flb_config_static_open(struct flb_config *config, const char *file)
{
    int i;
    int ret;
    const char *k = NULL;
    const char *v = NULL;
    struct flb_cf *cf;

    /* Iterate static array and lookup the file name */
    for (i = 0; i < flb_config_files_size; i++) {
        k = (const char *) flb_config_files[i][0];
        v = (const char *) flb_config_files[i][1];

        if (strcmp(k, file) == 0) {
            break;
        }
        k = NULL;
    }

    if (!k) {
        return NULL;
    }

    cf = flb_cf_fluentbit_create(NULL, (char *) file, (char *) v, 0);
    if (!cf) {
        return NULL;
    }

    if (config->cf_main) {
        flb_cf_destroy(config->cf_main);
    }
    config->cf_main = cf;

    return cf;
}
