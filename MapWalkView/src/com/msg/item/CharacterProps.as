package com.msg.item {
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
	public dynamic final class CharacterProps extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PROPS_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterProps.props_id", "propsId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var propsId:int;

		/**
		 *  @private
		 */
		public static const TEMPLATE_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterProps.template_id", "templateId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var templateId:int;

		/**
		 *  @private
		 */
		public static const QUANTITY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterProps.quantity", "quantity", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var quantity:int;

		/**
		 *  @private
		 */
		public static const OBTAIN_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterProps.obtain_time", "obtainTime", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var obtain_time$field:int;

		private var hasField$0:uint = 0;

		public function clearObtainTime():void {
			hasField$0 &= 0xfffffffe;
			obtain_time$field = new int();
		}

		public function get hasObtainTime():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set obtainTime(value:int):void {
			hasField$0 |= 0x1;
			obtain_time$field = value;
		}

		public function get obtainTime():int {
			return obtain_time$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.propsId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.templateId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.quantity);
			if (hasObtainTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, obtain_time$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var props_id$count:uint = 0;
			var template_id$count:uint = 0;
			var quantity$count:uint = 0;
			var obtain_time$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (props_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterProps.propsId cannot be set twice.');
					}
					++props_id$count;
					this.propsId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (template_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterProps.templateId cannot be set twice.');
					}
					++template_id$count;
					this.templateId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (quantity$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterProps.quantity cannot be set twice.');
					}
					++quantity$count;
					this.quantity = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (obtain_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterProps.obtainTime cannot be set twice.');
					}
					++obtain_time$count;
					this.obtainTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
