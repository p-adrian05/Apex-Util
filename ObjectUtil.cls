public with sharing class ObjectUtil {

    public with sharing class CustomException extends Exception {

    }
    public static Object requireNonNull(Object obj, String message){
        if (obj == null){
            throw new CustomException(message);
        }
        return obj;
    }
    public static String requireNonNull(String str, String message){
        if (str == null){
            throw new CustomException(message);
        }
        return str;
    }
    public static List<Object> requireNonEmpty(List<Object> objs, String message){
        if (objs?.size()==0){
            throw new CustomException(message);
        }
        return objs;
    }
    public static Object castStringToType(String type,String value){
        switch on type {
            when 'String'{
                return value;
            }
            when 'Decimal'{
                return Decimal.valueOf(value);
            }
            when 'Integer'{
                return Integer.valueOf(value);
            }
        }
        return value;
    }
}