/**
 * hub-detect
 *
 * Copyright (C) 2018 Black Duck Software, Inc.
 * http://www.blackducksoftware.com/
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package com.blackducksoftware.integration.hub.detect.codelocation;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

@Component
// used in 1.2.0 to 2.0.0
public class BomCodeLocationNameProvider2 extends CodeLocationNameProvider {
    @Override
    public String generateName(final CodeLocationName codeLocationName) {
        final String projectName = codeLocationName.getProjectName();
        final String projectVersionName = codeLocationName.getProjectVersionName();
        final String finalSourcePathPiece = detectFileManager.extractFinalPieceFromPath(codeLocationName.getSourcePath());
        final String bomToolString = codeLocationName.getBomToolType() == null ? "" : codeLocationName.getBomToolType().toString();
        final String prefix = codeLocationName.getPrefix();

        String name = String.format("%s/%s/%s/%s %s", bomToolString, finalSourcePathPiece, projectName, projectVersionName, CodeLocationType.BOM.toString());
        if (StringUtils.isNotBlank(prefix)) {
            name = String.format("%s/%s", prefix, name);
        }

        return name;
    }

}
