package com.msg.item {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.enumdef.ExtraAttr;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class EquipSuit extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SUIT_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.EquipSuit.suit_id", "suitId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var suitId:int;

		/**
		 *  @private
		 */
		public static const UNIT_NUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.EquipSuit.unit_num", "unitNum", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var unitNum:int;

		/**
		 *  @private
		 */
		public static const APP_ATTR_T1:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.item.EquipSuit.app_attr_t1", "appAttrT1", (3 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.ExtraAttr);

		public var appAttrT1:int;

		/**
		 *  @private
		 */
		public static const APP_ATTR_V1:FieldDescriptor$TYPE_FLOAT = new FieldDescriptor$TYPE_FLOAT("com.msg.item.EquipSuit.app_attr_v1", "appAttrV1", (4 << 3) | com.netease.protobuf.WireType.FIXED_32_BIT);

		public var appAttrV1:Number;

		/**
		 *  @private
		 */
		public static const APP_ATTR_T2:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.item.EquipSuit.app_attr_t2", "appAttrT2", (5 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.ExtraAttr);

		public var appAttrT2:int;

		/**
		 *  @private
		 */
		public static const APP_ATTR_V2:FieldDescriptor$TYPE_FLOAT = new FieldDescriptor$TYPE_FLOAT("com.msg.item.EquipSuit.app_attr_v2", "appAttrV2", (6 << 3) | com.netease.protobuf.WireType.FIXED_32_BIT);

		public var appAttrV2:Number;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.suitId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.unitNum);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.appAttrT1);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_32_BIT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_FLOAT(output, this.appAttrV1);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.appAttrT2);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_32_BIT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_FLOAT(output, this.appAttrV2);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var suit_id$count:uint = 0;
			var unit_num$count:uint = 0;
			var app_attr_t1$count:uint = 0;
			var app_attr_v1$count:uint = 0;
			var app_attr_t2$count:uint = 0;
			var app_attr_v2$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (suit_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipSuit.suitId cannot be set twice.');
					}
					++suit_id$count;
					this.suitId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (unit_num$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipSuit.unitNum cannot be set twice.');
					}
					++unit_num$count;
					this.unitNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (app_attr_t1$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipSuit.appAttrT1 cannot be set twice.');
					}
					++app_attr_t1$count;
					this.appAttrT1 = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 4:
					if (app_attr_v1$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipSuit.appAttrV1 cannot be set twice.');
					}
					++app_attr_v1$count;
					this.appAttrV1 = com.netease.protobuf.ReadUtils.read$TYPE_FLOAT(input);
					break;
				case 5:
					if (app_attr_t2$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipSuit.appAttrT2 cannot be set twice.');
					}
					++app_attr_t2$count;
					this.appAttrT2 = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 6:
					if (app_attr_v2$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipSuit.appAttrV2 cannot be set twice.');
					}
					++app_attr_v2$count;
					this.appAttrV2 = com.netease.protobuf.ReadUtils.read$TYPE_FLOAT(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
