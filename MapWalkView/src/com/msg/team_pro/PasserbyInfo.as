package com.msg.team_pro {
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
	public dynamic final class PasserbyInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.team_pro.PasserbyInfo.dy_id", "dyId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dyId:int;

		/**
		 *  @private
		 */
		public static const POWER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.team_pro.PasserbyInfo.power", "power", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var power:int;

		/**
		 *  @private
		 */
		public static const MEMBER_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.team_pro.PasserbyInfo.member_number", "memberNumber", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var member_number$field:int;

		private var hasField$0:uint = 0;

		public function clearMemberNumber():void {
			hasField$0 &= 0xfffffffe;
			member_number$field = new int();
		}

		public function get hasMemberNumber():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set memberNumber(value:int):void {
			hasField$0 |= 0x1;
			member_number$field = value;
		}

		public function get memberNumber():int {
			return member_number$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.dyId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.power);
			if (hasMemberNumber) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, member_number$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dy_id$count:uint = 0;
			var power$count:uint = 0;
			var member_number$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dy_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PasserbyInfo.dyId cannot be set twice.');
					}
					++dy_id$count;
					this.dyId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (power$count != 0) {
						throw new flash.errors.IOError('Bad data format: PasserbyInfo.power cannot be set twice.');
					}
					++power$count;
					this.power = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (member_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: PasserbyInfo.memberNumber cannot be set twice.');
					}
					++member_number$count;
					this.memberNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
