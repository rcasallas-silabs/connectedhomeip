/*
 *
 *    Copyright (c) 2023 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package matter.devicecontroller.cluster.clusters

import java.util.ArrayList

class OccupancySensingCluster(private val endpointId: UShort) {
  class GeneratedCommandListAttribute(val value: ArrayList<UInt>)

  class AcceptedCommandListAttribute(val value: ArrayList<UInt>)

  class EventListAttribute(val value: ArrayList<UInt>)

  class AttributeListAttribute(val value: ArrayList<UInt>)

  suspend fun readOccupancyAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun subscribeOccupancyAttribute(minInterval: Int, maxInterval: Int): Integer {
    // Implementation needs to be added here
  }

  suspend fun readOccupancySensorTypeAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun subscribeOccupancySensorTypeAttribute(minInterval: Int, maxInterval: Int): Integer {
    // Implementation needs to be added here
  }

  suspend fun readOccupancySensorTypeBitmapAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun subscribeOccupancySensorTypeBitmapAttribute(
    minInterval: Int,
    maxInterval: Int
  ): Integer {
    // Implementation needs to be added here
  }

  suspend fun readPIROccupiedToUnoccupiedDelayAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun writePIROccupiedToUnoccupiedDelayAttribute(value: UShort) {
    // Implementation needs to be added here
  }

  suspend fun writePIROccupiedToUnoccupiedDelayAttribute(value: UShort, timedWriteTimeoutMs: Int) {
    // Implementation needs to be added here
  }

  suspend fun subscribePIROccupiedToUnoccupiedDelayAttribute(
    minInterval: Int,
    maxInterval: Int
  ): Integer {
    // Implementation needs to be added here
  }

  suspend fun readPIRUnoccupiedToOccupiedDelayAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun writePIRUnoccupiedToOccupiedDelayAttribute(value: UShort) {
    // Implementation needs to be added here
  }

  suspend fun writePIRUnoccupiedToOccupiedDelayAttribute(value: UShort, timedWriteTimeoutMs: Int) {
    // Implementation needs to be added here
  }

  suspend fun subscribePIRUnoccupiedToOccupiedDelayAttribute(
    minInterval: Int,
    maxInterval: Int
  ): Integer {
    // Implementation needs to be added here
  }

  suspend fun readPIRUnoccupiedToOccupiedThresholdAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun writePIRUnoccupiedToOccupiedThresholdAttribute(value: UByte) {
    // Implementation needs to be added here
  }

  suspend fun writePIRUnoccupiedToOccupiedThresholdAttribute(
    value: UByte,
    timedWriteTimeoutMs: Int
  ) {
    // Implementation needs to be added here
  }

  suspend fun subscribePIRUnoccupiedToOccupiedThresholdAttribute(
    minInterval: Int,
    maxInterval: Int
  ): Integer {
    // Implementation needs to be added here
  }

  suspend fun readUltrasonicOccupiedToUnoccupiedDelayAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun writeUltrasonicOccupiedToUnoccupiedDelayAttribute(value: UShort) {
    // Implementation needs to be added here
  }

  suspend fun writeUltrasonicOccupiedToUnoccupiedDelayAttribute(
    value: UShort,
    timedWriteTimeoutMs: Int
  ) {
    // Implementation needs to be added here
  }

  suspend fun subscribeUltrasonicOccupiedToUnoccupiedDelayAttribute(
    minInterval: Int,
    maxInterval: Int
  ): Integer {
    // Implementation needs to be added here
  }

  suspend fun readUltrasonicUnoccupiedToOccupiedDelayAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun writeUltrasonicUnoccupiedToOccupiedDelayAttribute(value: UShort) {
    // Implementation needs to be added here
  }

  suspend fun writeUltrasonicUnoccupiedToOccupiedDelayAttribute(
    value: UShort,
    timedWriteTimeoutMs: Int
  ) {
    // Implementation needs to be added here
  }

  suspend fun subscribeUltrasonicUnoccupiedToOccupiedDelayAttribute(
    minInterval: Int,
    maxInterval: Int
  ): Integer {
    // Implementation needs to be added here
  }

  suspend fun readUltrasonicUnoccupiedToOccupiedThresholdAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun writeUltrasonicUnoccupiedToOccupiedThresholdAttribute(value: UByte) {
    // Implementation needs to be added here
  }

  suspend fun writeUltrasonicUnoccupiedToOccupiedThresholdAttribute(
    value: UByte,
    timedWriteTimeoutMs: Int
  ) {
    // Implementation needs to be added here
  }

  suspend fun subscribeUltrasonicUnoccupiedToOccupiedThresholdAttribute(
    minInterval: Int,
    maxInterval: Int
  ): Integer {
    // Implementation needs to be added here
  }

  suspend fun readPhysicalContactOccupiedToUnoccupiedDelayAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun writePhysicalContactOccupiedToUnoccupiedDelayAttribute(value: UShort) {
    // Implementation needs to be added here
  }

  suspend fun writePhysicalContactOccupiedToUnoccupiedDelayAttribute(
    value: UShort,
    timedWriteTimeoutMs: Int
  ) {
    // Implementation needs to be added here
  }

  suspend fun subscribePhysicalContactOccupiedToUnoccupiedDelayAttribute(
    minInterval: Int,
    maxInterval: Int
  ): Integer {
    // Implementation needs to be added here
  }

  suspend fun readPhysicalContactUnoccupiedToOccupiedDelayAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun writePhysicalContactUnoccupiedToOccupiedDelayAttribute(value: UShort) {
    // Implementation needs to be added here
  }

  suspend fun writePhysicalContactUnoccupiedToOccupiedDelayAttribute(
    value: UShort,
    timedWriteTimeoutMs: Int
  ) {
    // Implementation needs to be added here
  }

  suspend fun subscribePhysicalContactUnoccupiedToOccupiedDelayAttribute(
    minInterval: Int,
    maxInterval: Int
  ): Integer {
    // Implementation needs to be added here
  }

  suspend fun readPhysicalContactUnoccupiedToOccupiedThresholdAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun writePhysicalContactUnoccupiedToOccupiedThresholdAttribute(value: UByte) {
    // Implementation needs to be added here
  }

  suspend fun writePhysicalContactUnoccupiedToOccupiedThresholdAttribute(
    value: UByte,
    timedWriteTimeoutMs: Int
  ) {
    // Implementation needs to be added here
  }

  suspend fun subscribePhysicalContactUnoccupiedToOccupiedThresholdAttribute(
    minInterval: Int,
    maxInterval: Int
  ): Integer {
    // Implementation needs to be added here
  }

  suspend fun readGeneratedCommandListAttribute(): GeneratedCommandListAttribute {
    // Implementation needs to be added here
  }

  suspend fun subscribeGeneratedCommandListAttribute(
    minInterval: Int,
    maxInterval: Int
  ): GeneratedCommandListAttribute {
    // Implementation needs to be added here
  }

  suspend fun readAcceptedCommandListAttribute(): AcceptedCommandListAttribute {
    // Implementation needs to be added here
  }

  suspend fun subscribeAcceptedCommandListAttribute(
    minInterval: Int,
    maxInterval: Int
  ): AcceptedCommandListAttribute {
    // Implementation needs to be added here
  }

  suspend fun readEventListAttribute(): EventListAttribute {
    // Implementation needs to be added here
  }

  suspend fun subscribeEventListAttribute(minInterval: Int, maxInterval: Int): EventListAttribute {
    // Implementation needs to be added here
  }

  suspend fun readAttributeListAttribute(): AttributeListAttribute {
    // Implementation needs to be added here
  }

  suspend fun subscribeAttributeListAttribute(
    minInterval: Int,
    maxInterval: Int
  ): AttributeListAttribute {
    // Implementation needs to be added here
  }

  suspend fun readFeatureMapAttribute(): Long {
    // Implementation needs to be added here
  }

  suspend fun subscribeFeatureMapAttribute(minInterval: Int, maxInterval: Int): Long {
    // Implementation needs to be added here
  }

  suspend fun readClusterRevisionAttribute(): Integer {
    // Implementation needs to be added here
  }

  suspend fun subscribeClusterRevisionAttribute(minInterval: Int, maxInterval: Int): Integer {
    // Implementation needs to be added here
  }

  companion object {
    const val CLUSTER_ID: UInt = 1030u
  }
}