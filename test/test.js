var testReport = {
  pages: [
    {
      marginTop: 20,
      marginRight: 20,
      marginBottom: 20,
      marginLeft: 20,
      children: [
        {
          type: 'DataBand',
          name: 'dataBand1',
          rowCount: 100000,
          height: 30,
          children: [
            {
              type: 'Text',
              left: 0,
              top: 0,
              height: 18,
              width: 100,
              text: '{{row}} {{10*2.21}}'
            }, {
              type: 'Text',
              left: 100,
              top: 100,
              height: 18,
              width: 100,
              border: {
                left: true,
                bottom: true,
                top: true,
                right: true,
                width: 1,
                color: '#b1b1b1'
              },
              text: 'My 2nd text object'
            }
          ]
        }
      ]
    }
  ]
};
