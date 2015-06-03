package com.msg.raid_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SRaidInit extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TOTAL_ENEMY_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SRaidInit.total_enemy_number", "totalEnemyNumber", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var totalEnemyNumber:int;

		/**
		 *  @private
		 */
		public static const KILLED_ENEMY_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SRaidInit.killed_enemy_number", "killedEnemyNumber", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var killedEnemyNumber:int;

		/**
		 *  @private
		 */
		public static const TOTAL_WAVE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SRaidInit.total_wave", "totalWave", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var total_wave$field:int;

		private var hasField$0:uint = 0;

		public function clearTotalWave():void {
			hasField$0 &= 0xfffffffe;
			total_wave$field = new int();
		}

		public function get hasTotalWave():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set totalWave(value:int):void {
			hasField$0 |= 0x1;
			total_wave$field = value;
		}

		public function get totalWave():int {
			return total_wave$field;
		}

		/**
		 *  @private
		 */
		public static const CURRENT_WAVE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SRaidInit.current_wave", "currentWave", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var current_wave$field:int;

		public function clearCurrentWave():void {
			hasField$0 &= 0xfffffffd;
			current_wave$field = new int();
		}

		public function get hasCurrentWave():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set currentWave(value:int):void {
			hasField$0 |= 0x2;
			current_wave$field = value;
		}

		public function get currentWave():int {
			return current_wave$field;
		}

		/**
		 *  @private
		 */
		public static const WAIT_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SRaidInit.wait_time", "waitTime", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var wait_time$field:int;

		public function clearWaitTime():void {
			hasField$0 &= 0xfffffffb;
			wait_time$field = new int();
		}

		public function get hasWaitTime():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set waitTime(value:int):void {
			hasField$0 |= 0x4;
			wait_time$field = value;
		}

		public function get waitTime():int {
			return wait_time$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.totalEnemyNumber);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.killedEnemyNumber);
			if (hasTotalWave) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, total_wave$field);
			}
			if (hasCurrentWave) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, current_wave$field);
			}
			if (hasWaitTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, wait_time$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var total_enemy_number$count:uint = 0;
			var killed_enemy_number$count:uint = 0;
			var total_wave$count:uint = 0;
			var current_wave$count:uint = 0;
			var wait_time$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (total_enemy_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRaidInit.totalEnemyNumber cannot be set twice.');
					}
					++total_enemy_number$count;
					this.totalEnemyNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (killed_enemy_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRaidInit.killedEnemyNumber cannot be set twice.');
					}
					++killed_enemy_number$count;
					this.killedEnemyNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (total_wave$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRaidInit.totalWave cannot be set twice.');
					}
					++total_wave$count;
					this.totalWave = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (current_wave$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRaidInit.currentWave cannot be set twice.');
					}
					++current_wave$count;
					this.currentWave = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (wait_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRaidInit.waitTime cannot be set twice.');
					}
					++wait_time$count;
					this.waitTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
