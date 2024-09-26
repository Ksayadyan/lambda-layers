import { v4 as uuid } from 'uuid'

export const handler = async (event) => {
    const response = {
        statusCode: 200,
        body: JSON.stringify({ uuid: uuid() }),
    };
    return response;
};
