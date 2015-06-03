package com.msg.guild {
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
	public dynamic final class SAccuseResult extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const IS_SUCCESS:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.guild.SAccuseResult.is_success", "isSuccess", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var isSuccess:Boolean;

		/**
		 *  @private
		 */
		public static const NEW_CHAIRMAN_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SAccuseResult.new_chairman_id", "newChairmanId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var new_chairman_id$field:int;

		private var hasField$0:uint = 0;

		public function clearNewChairmanId():void {
			hasField$0 &= 0xfffffffe;
			new_chairman_id$field = new int();
		}

		public function get hasNewChairmanId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set newChairmanId(value:int):void {
			hasField$0 |= 0x1;
			new_chairman_id$field = value;
		}

		public function get newChairmanId():int {
			return new_chairman_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.isSuccess);
			if (hasNewChairmanId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, new_chairman_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var is_success$count:uint = 0;
			var new_chairman_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (is_success$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAccuseResult.isSuccess cannot be set twice.');
					}
					++is_success$count;
					this.isSuccess = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 2:
					if (new_chairman_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAccuseResult.newChairmanId cannot be set twice.');
					}
					++new_chairman_id$count;
					this.newChairmanId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
