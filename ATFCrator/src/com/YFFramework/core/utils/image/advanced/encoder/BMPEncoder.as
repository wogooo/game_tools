package com.YFFramework.core.utils.image.advanced.encoder
{
    import com.YFFramework.core.utils.image.advanced.encoder.Encoder;
    
    import flash.display.*;
    import flash.utils.*;

    public class BMPEncoder extends Object implements Encoder
    {

        public function BMPEncoder()
        {
            return;
        }// end function

        public  function encode(param1:BitmapData) : ByteArray
        {
            var bitmapData:* = param1;
            var bmpWidth:* = bitmapData.width;
            var bmpHeight:* = bitmapData.height;
            var imageBytes:* = bitmapData.getPixels(bitmapData.rect);
            var imageSize:* = imageBytes.length;
            var imageDataOffset:int;
            var fileSize:* = imageSize + imageDataOffset;
            var bmpBytes:* = new ByteArray();
            bmpBytes.endian = Endian.LITTLE_ENDIAN;
            bmpBytes.length = fileSize;
            bmpBytes.writeByte(66);
            bmpBytes.writeByte(77);
            bmpBytes.writeInt(fileSize);
            bmpBytes.position = 10;
            bmpBytes.writeInt(imageDataOffset);
            bmpBytes.writeInt(40);
            bmpBytes.position = 18;
            bmpBytes.writeInt(bmpWidth);
            bmpBytes.writeInt(bmpHeight);
            bmpBytes.writeShort(1);
            bmpBytes.writeShort(32);
            bmpBytes.writeInt(0);
            bmpBytes.writeInt(imageSize);
            bmpBytes.position = imageDataOffset;
            var col:* = bmpWidth;
            var row:* = bmpHeight;
            var rowLength:* = col * 4;
            try
            {
                imageBytes.position = 0;
                do
                {
                    
                    bmpBytes.position = imageDataOffset + row * rowLength;
                    col = bmpWidth;
                    do
                    {
                        
                        bmpBytes.writeInt(imageBytes.readInt());
                        col = (col - 1);
                    }while (col)
                    row = (row - 1);
                }while (row)
            }
            catch (error:Error)
            {
            }
            return bmpBytes;
        }// end function

    }
}
