package com.msg.raid_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.common.ItemConsume;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CEnterRaid extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RAID_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.CEnterRaid.raid_id", "raidId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var raidId:int;

		/**
		 *  @private
		 */
		public static const NPC_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.CEnterRaid.npc_id", "npcId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var npc_id$field:int;

		private var hasField$0:uint = 0;

		public function clearNpcId():void {
			hasField$0 &= 0xfffffffe;
			npc_id$field = new int();
		}

		public function get hasNpcId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set npcId(value:int):void {
			hasField$0 |= 0x1;
			npc_id$field = value;
		}

		public function get npcId():int {
			return npc_id$field;
		}

		/**
		 *  @private
		 */
		public static const ITEMS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.raid_pro.CEnterRaid.items", "items", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.ItemConsume; });

		[ArrayElementType("com.msg.common.ItemConsume")]
		public var items:Array = [];

		/**
		 *  @private
		 */
		public static const PARAM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.CEnterRaid.param", "param", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var param$field:int;

		public function clearParam():void {
			hasField$0 &= 0xfffffffd;
			param$field = new int();
		}

		public function get hasParam():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set param(value:int):void {
			hasField$0 |= 0x2;
			param$field = value;
		}

		public function get param():int {
			return param$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.raidId);
			if (hasNpcId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, npc_id$field);
			}
			for (var items$index:uint = 0; items$index < this.items.length; ++items$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.items[items$index]);
			}
			if (hasParam) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, param$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var raid_id$count:uint = 0;
			var npc_id$count:uint = 0;
			var param$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (raid_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CEnterRaid.raidId cannot be set twice.');
					}
					++raid_id$count;
					this.raidId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (npc_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CEnterRaid.npcId cannot be set twice.');
					}
					++npc_id$count;
					this.npcId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					this.items.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.ItemConsume()));
					break;
				case 4:
					if (param$count != 0) {
						throw new flash.errors.IOError('Bad data format: CEnterRaid.param cannot be set twice.');
					}
					++param$count;
					this.param = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
