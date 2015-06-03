package com.msg.item {
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
	public dynamic final class CEnhanceEquipReq extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CEnhanceEquipReq.pos", "pos", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var pos:int;

		/**
		 *  @private
		 */
		public static const STONE:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.item.CEnhanceEquipReq.stone", "stone", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.ItemConsume; });

		[ArrayElementType("com.msg.common.ItemConsume")]
		public var stone:Array = [];

		/**
		 *  @private
		 */
		public static const SUB_DIAMOND:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.item.CEnhanceEquipReq.sub_diamond", "subDiamond", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var sub_diamond$field:Boolean;

		private var hasField$0:uint = 0;

		public function clearSubDiamond():void {
			hasField$0 &= 0xfffffffe;
			sub_diamond$field = new Boolean();
		}

		public function get hasSubDiamond():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set subDiamond(value:Boolean):void {
			hasField$0 |= 0x1;
			sub_diamond$field = value;
		}

		public function get subDiamond():Boolean {
			return sub_diamond$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.pos);
			for (var stone$index:uint = 0; stone$index < this.stone.length; ++stone$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.stone[stone$index]);
			}
			if (hasSubDiamond) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, sub_diamond$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var pos$count:uint = 0;
			var sub_diamond$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CEnhanceEquipReq.pos cannot be set twice.');
					}
					++pos$count;
					this.pos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					this.stone.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.ItemConsume()));
					break;
				case 3:
					if (sub_diamond$count != 0) {
						throw new flash.errors.IOError('Bad data format: CEnhanceEquipReq.subDiamond cannot be set twice.');
					}
					++sub_diamond$count;
					this.subDiamond = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
