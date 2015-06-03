package com.msg.item {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.enumdef.BindingType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SModifyPropsBinding extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PROPS_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyPropsBinding.props_id", "propsId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var propsId:int;

		/**
		 *  @private
		 */
		public static const BINDING_ATTR:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.item.SModifyPropsBinding.binding_attr", "bindingAttr", (2 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.BindingType);

		public var bindingAttr:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.propsId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.bindingAttr);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var props_id$count:uint = 0;
			var binding_attr$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (props_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyPropsBinding.propsId cannot be set twice.');
					}
					++props_id$count;
					this.propsId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (binding_attr$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyPropsBinding.bindingAttr cannot be set twice.');
					}
					++binding_attr$count;
					this.bindingAttr = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
